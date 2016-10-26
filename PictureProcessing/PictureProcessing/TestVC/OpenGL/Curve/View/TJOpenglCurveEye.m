//
//  TJOpenglCurveEye.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglCurveEye.h"
#import "TJ_Opengl_C.h"
#import "TJURLSession.h"


NSString *const TJ_CurveEyeVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_CurveEyeFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D colorMap;
 void main()
 {
     gl_FragColor = texture2D(colorMap, varyTextCoord);
 }
 
 );





@interface TJOpenglCurveEye ()

@property (nonatomic, strong) UIImage           *orginImg;
@property (nonatomic, strong) UIImage           *renderImg;


@end


@implementation TJOpenglCurveEye
{
    CGImageRef      rfImage;
    
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
    
        
        self.backgroundColor = [UIColor whiteColor];
        self.orginImg = image;
        self.renderImg = image;
        
        self.ImgWidth = self.orginImg.size.width;
        self.ImgHeight = self.orginImg.size.height;
        
        VertexShaderString = TJ_CurveEyeVertexShaderString;
        FragmentShaderString = TJ_CurveEyeFragmentShaderString;
        
        
        aspectRatio = image.size.height / image.size.width;
        rectW = 100;
        rectH = rectW * (image.size.width / image.size.height);
        rectLength = rectW * rectH;
        attrArr = (GLfloat *)malloc(5 * rectLength * sizeof(GLfloat));
        configure_attrArr(attrArr, rectW, rectH);
        
        indices = (GLint *)malloc((rectW - 1) * (rectH - 1) * 2 * 3 * sizeof(GLint));
        configure_indices(indices, rectW, rectH);
        
        [self getFaceFreature];
        
    }
    return self;
    
}


- (void)getFaceFreature
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_7.JPG" ofType:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:MG_LICENSE_KEY forKey:@"api_key"];
    [dict setValue:MG_LICENSE_SECRE forKey:@"api_secret"];
    [dict setValue:@1 forKey:@"return_landmark"];
    
    NSString *url = @"https://api.megvii.com/facepp/v3/detect";
    
    [TJURLSession postWithUrl:url parameters:dict paths:@[path] fieldName:@"image_file" completion:^(id responseObject, int status) {
        
        NSLog(@"%@", responseObject);
        
        CGFloat rateW = self.ImgWidth / self.bounds.size.width;
        CGFloat rateH = self.ImgHeight / self.bounds.size.height;
        
        NSArray *array = [responseObject valueForKey:@"faces"];
        NSDictionary *face = [array firstObject];
        NSDictionary *face_rectangle = [face valueForKey:@"face_rectangle"];
        
        CGFloat height = [[face_rectangle valueForKey:@"height"] floatValue];
        CGFloat left = [[face_rectangle valueForKey:@"left"] floatValue];
        CGFloat top = [[face_rectangle valueForKey:@"top"] floatValue];
        CGFloat width = [[face_rectangle valueForKey:@"width"] floatValue];
        
        UIView *faceView = [[UIView alloc] initWithFrame:CGRectMake(left / rateW, top / rateH, width / rateW, height / rateH)];
        [self addSubview:faceView];
        faceView.backgroundColor = [UIColor redColor];
        
        
        
        
        NSDictionary *landmark = [face valueForKey:@"landmark"];
        
        NSDictionary *left_eye_top = [landmark valueForKey:@"left_eye_top"];
        NSDictionary *left_eye_bottom = [landmark valueForKey:@"left_eye_bottom"];
        
        NSDictionary *left_eye_left_corner = [landmark valueForKey:@"left_eye_left_corner"];
        NSDictionary *left_eye_right_corner = [landmark valueForKey:@"left_eye_right_corner"];
        
        CGPoint eye_top = CGPointMake([[left_eye_top valueForKey:@"x"] floatValue], [[left_eye_top valueForKey:@"y"] floatValue]);
        CGPoint eye_bottom = CGPointMake([[left_eye_bottom valueForKey:@"x"] floatValue], [[left_eye_bottom valueForKey:@"y"] floatValue]);
        
        CGPoint eye_left_corner = CGPointMake([[left_eye_left_corner valueForKey:@"x"] floatValue], [[left_eye_left_corner valueForKey:@"y"] floatValue]);
        CGPoint eye_right_corner = CGPointMake([[left_eye_right_corner valueForKey:@"x"] floatValue], [[left_eye_right_corner valueForKey:@"y"] floatValue]);
        
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(eye_left_corner.x / rateW, eye_top.y / rateH, (eye_right_corner.x - eye_left_corner.x) / rateH, (eye_bottom.y - eye_top.y) / rateH)];
        [self addSubview:redView];
        redView.backgroundColor = [UIColor redColor];
        
        eye_top = CGPointMake(eye_top.x / self.ImgWidth * 2 - 1, 1 - eye_top.y / self.ImgHeight * 2);
        eye_bottom = CGPointMake(eye_bottom.x / self.ImgWidth * 2 - 1, 1 - eye_bottom.y / self.ImgHeight * 2);
        eye_left_corner = CGPointMake(eye_left_corner.x / self.ImgWidth * 2 - 1, 1 - eye_left_corner.y / self.ImgHeight * 2);
        eye_right_corner = CGPointMake(eye_right_corner.x / self.ImgWidth * 2 - 1, 1 - eye_right_corner.y / self.ImgHeight * 2);
        
        
        for (int i = 0; i < rectLength; i++)
        {
            float x = attrArr[i * 5];
            float y = attrArr[i * 5 + 1];
            
            if (x > MIN(eye_left_corner.x, eye_right_corner.x) &&
                x > MAX(eye_left_corner.x, eye_right_corner.x) &&
                y > MIN(eye_top.y, eye_bottom.y) &&
                y < MAX(eye_top.y, eye_bottom.y)
                ) {
                attrArr[i * 5 + 1] = eye_bottom.y;
            }
            
        }
        
        
    }];

    
    
    
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
    
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self render];
}



@end
