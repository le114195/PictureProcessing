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
 
 uniform highp vec2 eye_top;
 uniform highp vec2 eye_bottom;
 uniform highp vec2 eye_left_corner;
 uniform highp vec2 eye_right_corner;
 uniform highp vec2 eyebrow_lower_middle;
 
 uniform highp vec2 eye_direction;
 
 void main()
 {
     
     highp float x = varyTextCoord.x;
     highp float y = varyTextCoord.y;

     highp float dir_x = eye_direction.x;
     highp float dir_y = eye_direction.y;
     
//     dir_y = 2 * dir_y;
     
     if (dir_y < -y){
         gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
     }else {
         gl_FragColor = texture2D(colorMap, varyTextCoord);
     }

     
 }
 
 );





@interface TJOpenglCurveEye ()

@property (nonatomic, assign) CGPoint       eye_top;
@property (nonatomic, assign) CGPoint       eye_bottom;
@property (nonatomic, assign) CGPoint       eye_left_corner;
@property (nonatomic, assign) CGPoint       eye_right_corner;
@property (nonatomic, assign) CGPoint       eyebrow_lower_middle;

@property (nonatomic, assign) CGPoint       eye_direction;


@end


@implementation TJOpenglCurveEye
{
    CGImageRef      rfImage;

    CGPoint         previousLocation;
    
    GLint           rectW;
    GLint           rectH;
    GLint           rectLength;
    
    GLfloat         *attrArr;
    
    GLint           *indices;
    
    GLfloat         aspectRatio;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if ([super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.originImg = image;
        self.renderImg = image;
        
        self.ImgWidth = image.size.width;
        self.ImgHeight = image.size.height;
        
        VertexShaderString = TJ_CurveEyeVertexShaderString;
        FragmentShaderString = TJ_CurveEyeFragmentShaderString;
        
        
        aspectRatio = image.size.height / image.size.width;
        
        rectW = 2;
        rectH = 2;
        
        rectLength = rectW * rectH;
        attrArr = (GLfloat *)malloc(5 * rectLength * sizeof(GLfloat));
        configure_attrArr(attrArr, rectW, rectH);
        
        
        indices = (GLint *)malloc((rectW - 1) * (rectH - 1) * 2 * 3 * sizeof(GLint));
        configure_indices(indices, rectW, rectH);
     
        
        
        self.eye_direction = CGPointMake(0, 0);
        
        
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



- (void)render {
    
    [self resetAttr];
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, rectLength * 5 * sizeof(GLfloat), attrArr, GL_STATIC_DRAW);
    
    
    [self setPoint:self.eye_top name:@"eye_top"];
    [self setPoint:self.eye_bottom name:@"eye_bottom"];
    [self setPoint:self.eye_left_corner name:@"eye_left_corner"];
    [self setPoint:self.eye_right_corner name:@"eye_right_corner"];
    [self setPoint:self.eyebrow_lower_middle name:@"eyebrow_lower_middle"];
    
    [self setPoint:self.eye_direction name:@"eye_direction"];
    
    
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





- (void)getFaceFreature
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_9.JPG" ofType:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:MG_LICENSE_KEY forKey:@"api_key"];
    [dict setValue:MG_LICENSE_SECRE forKey:@"api_secret"];
    [dict setValue:@1 forKey:@"return_landmark"];
    
    NSString *url = @"https://api.megvii.com/facepp/v3/detect";
    
    [TJURLSession postWithUrl:url parameters:dict paths:@[path] fieldName:@"image_file" completion:^(id responseObject, int status) {
        
        NSLog(@"%@", responseObject);
        
        NSArray *array = [responseObject valueForKey:@"faces"];
        NSDictionary *face = [array firstObject];
        NSDictionary *face_rectangle = [face valueForKey:@"face_rectangle"];
        
        
        
        NSDictionary *landmark = [face valueForKey:@"landmark"];
        
        NSDictionary *left_eye_top = [landmark valueForKey:@"left_eye_top"];
        NSDictionary *left_eye_bottom = [landmark valueForKey:@"left_eye_bottom"];
        
        NSDictionary *left_eye_left_corner = [landmark valueForKey:@"left_eye_left_corner"];
        NSDictionary *left_eye_right_corner = [landmark valueForKey:@"left_eye_right_corner"];
        
        NSDictionary *left_eyebrow_lower_middle = [landmark valueForKey:@"left_eyebrow_lower_middle"];
        
        
        _eye_top = CGPointMake([[left_eye_top valueForKey:@"x"] floatValue], [[left_eye_top valueForKey:@"y"] floatValue]);
        _eye_bottom = CGPointMake([[left_eye_bottom valueForKey:@"x"] floatValue], [[left_eye_bottom valueForKey:@"y"] floatValue]);
        
        _eye_left_corner = CGPointMake([[left_eye_left_corner valueForKey:@"x"] floatValue], [[left_eye_left_corner valueForKey:@"y"] floatValue]);
        _eye_right_corner = CGPointMake([[left_eye_right_corner valueForKey:@"x"] floatValue], [[left_eye_right_corner valueForKey:@"y"] floatValue]);
        
        _eyebrow_lower_middle = CGPointMake([[left_eyebrow_lower_middle valueForKey:@"x"] floatValue], [[left_eyebrow_lower_middle valueForKey:@"y"] floatValue]);
        

        _eye_top = CGPointMake(_eye_top.x / self.ImgWidth, _eye_top.y / self.ImgHeight);
        _eye_bottom = CGPointMake(_eye_bottom.x / self.ImgWidth, _eye_bottom.y / self.ImgHeight);
        _eye_left_corner = CGPointMake(_eye_left_corner.x / self.ImgWidth, _eye_left_corner.y / self.ImgHeight);
        _eye_right_corner = CGPointMake(_eye_right_corner.x / self.ImgWidth, _eye_right_corner.y / self.ImgHeight);
        
        _eyebrow_lower_middle = CGPointMake(_eyebrow_lower_middle.x / self.ImgWidth, _eyebrow_lower_middle.y / self.ImgHeight);
        
        self.eye_direction = CGPointMake(_eyebrow_lower_middle.x - _eye_top.x, _eyebrow_lower_middle.y - _eye_top.y);
        
        _eye_top = CGPointMake((_eye_top.x + _eyebrow_lower_middle.x) * 0.5, (_eye_top.y + _eyebrow_lower_middle.y) * 0.5);
        
        
        
        //        _eye_bottom = CGPointMake(_eye_top.x + (_eyebrow_lower_middle.x - _eye_top.x) * 0.2, _eye_top.y + (_eyebrow_lower_middle.y - _eye_top.y) * 0.2);
        
        
        
        NSLog(@"_eye_top = %@", NSStringFromCGPoint(_eye_top));
        NSLog(@"_eye_bottom = %@", NSStringFromCGPoint(_eye_bottom));
        NSLog(@"_eye_left_corner = %@", NSStringFromCGPoint(_eye_left_corner));
        NSLog(@"_eye_right_corner = %@", NSStringFromCGPoint(_eye_right_corner));
        NSLog(@"_eyebrow_lower_middle = %@", NSStringFromCGPoint(_eyebrow_lower_middle));
        
        
        
        /*
        CGFloat offset = (eyebrow_lower_middle.y - eye_top.y) * 0.5;
        CGFloat dist = sqrt((eye_top.x - eye_bottom.x)*(eye_top.x - eye_bottom.x) + (eye_top.y - eye_bottom.y)*(eye_top.y - eye_bottom.y));
        
        NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
        
        
        for (int i = 0; i < rectLength; i++)
        {
            float x = attrArr[i * 5];
            float y = attrArr[i * 5 + 1];
            
            if (x > MIN(eye_left_corner.x, eye_right_corner.x) &&
                x < MAX(eye_left_corner.x, eye_right_corner.x) &&
                y > MIN(eye_top.y, eye_bottom.y) &&
                y < MAX(eye_top.y + offset, eye_bottom.y)
                ) {
                attrArr[i * 5 + 1] = eye_bottom.y;
            }
            
        }
        NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
         */
         
        [self render];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getFaceFreature];
}



@end
