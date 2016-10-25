//
//  TJOpenglesCurve.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/13.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesCurve.h"
#import "OpenglTool.h"
#import "TJ_DrawTool.h"
#import "TJ_Opengl_C.h"


NSString *const TJ_CurveVertexShaderString = TJ_STRING_ES
(
 attribute vec4 position;
 attribute vec2 textCoordinate;
 
 uniform mat4 projectionMatrix;
 uniform mat4 modelViewMatrix;
 
 varying lowp vec2 varyTextCoord;
 
 void main()
{
    varyTextCoord = textCoordinate;
    
    gl_Position = position;
}
 );


NSString *const TJ_CurveFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D colorMap;
 void main()
 {
     gl_FragColor = texture2D(colorMap, varyTextCoord);
 }

 );


@interface TJOpenglesCurve ()

@property (nonatomic, strong) UIImage           *image;

@property (nonatomic, strong) UIImage       *renderImg;

@property (nonatomic, assign) CGPoint       locationPoint;
@property (nonatomic, assign) CGPoint       previousPoint;


@end


@implementation TJOpenglesCurve
{
    CGImageRef      rfImage;
    BOOL            firstTouch;
    CGPoint         previousLocation;
    
    GLint           rectW;
    GLint           rectH;
    GLint           rectLength;
    
    GLfloat         *attrArr;
    
    GLint           *indices;
    
    GLfloat         aspectRatio;
}



- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if ([super initWithFrame:frame]) {
        
        firstTouch = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        self.image = image;
        self.renderImg = image;
        
        self.ImgWidth = self.image.size.width;
        self.ImgHeight = self.image.size.height;
        
        VertexShaderString = TJ_CurveVertexShaderString;
        FragmentShaderString = TJ_CurveFragmentShaderString;
        
        
        aspectRatio = image.size.height / image.size.width;
        rectW = 100;
        rectH = rectW * (image.size.width / image.size.height);
        rectLength = rectW * rectH;
        attrArr = (GLfloat *)malloc(5 * rectLength * sizeof(GLfloat));
        configure_attrArr(attrArr, rectW, rectH);
        
        indices = (GLint *)malloc((rectW - 1) * (rectH - 1) * 2 * 3 * sizeof(GLint));
        configure_indices(indices, rectW, rectH);
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self render];
}




#pragma mark - 纹理
- (GLuint)setupTexture:(UIImage *)image {
    // 1获取图片的CGImageRef
    rfImage = image.CGImage;
    if (!rfImage) {
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(rfImage);
    size_t height = CGImageGetHeight(rfImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(rfImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), rfImage);
    
    CGContextRelease(spriteContext);
    
    // 4绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    free(spriteData);
    return 0;
}


#pragma mark - 渲染
- (void)render {
    
    [self resetAttr];
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, rectLength * 5 * sizeof(GLfloat), attrArr, GL_STATIC_DRAW);
    
    GLuint position = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(position);
    
    GLuint textCoor = glGetAttribLocation(self.myProgram, "textCoordinate");
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);
    glEnableVertexAttribArray(textCoor);
    
    
    [self setupTexture:self.renderImg];
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawElements(GL_TRIANGLES, (rectW - 1)*(rectH - 1) * 6, GL_UNSIGNED_INT, indices);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
    
//        self.renderImg = [OpenglTool tj_glTOImageWithSize:CGSizeMake(self.ImgWidth, self.ImgHeight)];
}

/** 布局三角面片 */
- (void)resetAttr
{
    if (firstTouch) {
        return;
    }
    float rateX = 0, rateY = 0;
    if (self.previousPoint.y == self.locationPoint.y) {
        if (self.previousPoint.x > self.locationPoint.x) {
            rateX = 1;
        }else {
            rateX = -1;
        }
    }else {
        float dis = sqrt((self.locationPoint.x - self.previousPoint.x)*(self.locationPoint.x - self.previousPoint.x) + (self.locationPoint.y - self.previousPoint.y)*(self.locationPoint.y - self.previousPoint.y));
        rateX = (self.previousPoint.x - self.locationPoint.x)/dis;
        rateY = (self.previousPoint.y - self.locationPoint.y)/dis;
    }
    
    CGPoint centerPoint = CGPointMake((self.previousPoint.x - 0.5) * 2, (0.5 - self.previousPoint.y) * 2);
    
    GLfloat     dist = 0, radius = 0.35, percent;
    for (int i = 0; i < rectLength; i++) {
        float converY = (attrArr[i * 5 + 1] - centerPoint.y) * aspectRatio + centerPoint.y;
        dist = sqrt((attrArr[i * 5] - centerPoint.x)*(attrArr[i * 5] - centerPoint.x) + (converY - centerPoint.y)*(converY - centerPoint.y));
        if (dist < radius) {
            percent = (radius - dist) / radius * 0.1;
            percent = percent * percent;
            
            attrArr[i * 5] = attrArr[i * 5] - rateX * percent;
            attrArr[i * 5 + 1] = attrArr[i * 5 + 1] + rateY * percent;
            
            //边界处理
            if (i%rectW == 0) {//左边界
                if (attrArr[i * 5] > -1) {
                    attrArr[i * 5] = -1;
                }
            }
            if (i%rectW == rectW - 1) {//右边界
                if (attrArr[i * 5] < 1) {
                    attrArr[i * 5] = 1;
                }
            }
            if (i/rectW == 0) {//上边界
                if (attrArr[i * 5 + 1] < 1) {
                    attrArr[i * 5 + 1] = 1;
                }
            }
            if (i/rectW == rectH - 1) {//下边界
                if (attrArr[i * 5 + 1] > -1) {
                    attrArr[i * 5 + 1] = -1;
                }
            }
        }
    }
}




// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*            touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    CGPoint location = [touch locationInView:self];
    previousLocation = location;
    self.locationPoint = CGPointMake(location.x/self.bounds.size.width, location.y/self.bounds.size.height);
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstTouch = NO;
    UITouch*			touch = [[event touchesForView:self] anyObject];
    CGPoint location = [touch locationInView:self];
    self.locationPoint = CGPointMake(location.x/self.bounds.size.width, location.y/self.bounds.size.height);
    
    if (sqrt((location.x - previousLocation.x)*(location.x - previousLocation.x) + (location.y - previousLocation.y)*(location.y - previousLocation.y)) < 3) {
        return;
    }
    self.previousPoint = CGPointMake(previousLocation.x/self.bounds.size.width, previousLocation.y/self.bounds.size.height);
    previousLocation = location;
    [self render];
}



@end
