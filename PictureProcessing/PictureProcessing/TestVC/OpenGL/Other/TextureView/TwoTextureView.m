//
//  TwoTextureView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/1/20.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TwoTextureView.h"


NSString *const TJ_TwoTextureVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_TwoTextureFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D textureColor1;
 uniform sampler2D textureColor2;
 void main()
 {
     if (varyTextCoord.x < 0.5) {
         gl_FragColor = texture2D(textureColor2, varyTextCoord);
     }else {
         gl_FragColor = texture2D(textureColor1, varyTextCoord);
     }
 }
 );


@implementation TwoTextureView
{
    CGImageRef      rfImage;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if ([super initWithFrame:frame]) {
        VertexShaderString = TJ_TwoTextureVertexShaderString;
        FragmentShaderString = TJ_TwoTextureFragmentShaderString;
        
        self.renderImg = image;
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupTexture];
    [self render];
}


- (void)bindTextureImage:(UIImage *)image
{
    GLuint textureID;
    
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
    
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
}


- (void)setupTexture {
    
    UIImage *image1 = [UIImage imageNamed:@"sj_20160705_10.JPG"];
    glActiveTexture(GL_TEXTURE0);
    [self bindTextureImage:image1];
    //将纹理与片段着色器对应起来
    GLuint textureLocation1 = glGetUniformLocation(self.myProgram, "textureColor1");
    glUniform1i(textureLocation1, 0);
    
    
    UIImage *image2 = [UIImage imageNamed:@"sj_20160705_11.JPG"];
    glActiveTexture(GL_TEXTURE1);
    [self bindTextureImage:image2];
    //将纹理与片段着色器对应起来
    GLuint textureLocation2 = glGetUniformLocation(self.myProgram, "textureColor2");
    glUniform1i(textureLocation2, 1);
}

- (void)render {
    
    //坐标数组
    GLfloat attrArr[] =
    {
        1.0f, -1.0f, 0.0f,     1.0f, 1.0f,
        -1.0f, 1.0f, 0.0f,     0.0f, 0.0f,
        -1.0f, -1.0f, 0.0f,    0.0f, 1.0f,
        1.0f, 1.0f, 0.0f,      1.0f, 0.0f,
        -1.0f, 1.0f, 0.0f,     0.0f, 0.0f,
        1.0f, -1.0f, 0.0f,     1.0f, 1.0f,
    };
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    
    GLuint position = glGetAttribLocation(self.myProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(position);
    
    GLuint textCoor = glGetAttribLocation(self.myProgram, "textCoordinate");
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);
    glEnableVertexAttribArray(textCoor);
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawArrays(GL_TRIANGLES, 0, 12);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}


@end
