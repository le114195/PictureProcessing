//
//  OpenGLBrushDemo2.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/10.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenGLBrushDemo2.h"


NSString *const TJ_Brush2VertexShaderString = TJ_STRING_ES
(
 attribute vec4 inVertex;
 
 uniform lowp vec4 vertexColor;
 
 uniform mat4 MVP;
 uniform float pointSize;
 
 varying lowp vec4 color;
 
 void main()
 {
     gl_Position = MVP * inVertex;
     gl_PointSize = pointSize;
     
     color = vertexColor;
 }
 );

NSString *const TJ_Brush2FragmentShaderString = TJ_STRING_ES
(
 uniform sampler2D texture;
 varying lowp vec4 color;
 void main()
 {
     gl_FragColor = color * texture2D(texture, gl_PointCoord);
 }
 );

@implementation OpenGLBrushDemo2
{
    CGFloat brushTextureW;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        VertexShaderString = TJ_Brush2VertexShaderString;
        FragmentShaderString = TJ_Brush2FragmentShaderString;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self setupTexture];
    
    [self setupShaderParameters];
    
    [self render];
}

- (void)setupTexture
{
    UIImage *image1 = [UIImage imageNamed:@"test128.png"];
    glActiveTexture(GL_TEXTURE0);
    [self bindTextureImage:image1];
    
    brushTextureW = image1.size.width;
}

/** 着色器参数初始化 */
- (void)setupShaderParameters
{
    glUniform1i(glGetUniformLocation(self.myProgram, "texture"), 0);
    
    // viewing matrices
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.bounds.size.width * self.scale, 0, self.bounds.size.height * self.scale, -1, 1);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUniformMatrix4fv(glGetUniformLocation(self.myProgram, "MVP"), 1, GL_FALSE, MVPMatrix.m);
    
    // point size
    glUniform1f(glGetUniformLocation(self.myProgram, "pointSize"), brushTextureW / 2);
    
    
    CGFloat brushOpacity = 0.3;
    
    
    GLfloat brushColor[4];
    
    brushColor[0] = 1.0 * brushOpacity;
    brushColor[1] = 0.5 * brushOpacity;
    brushColor[2] = 0.7 * brushOpacity;
    brushColor[3] = brushOpacity;
    
    glUniform4fv(glGetUniformLocation(self.myProgram, "vertexColor"), 1, brushColor);
    
}



- (void)render {
    
    //坐标数组
    GLfloat attrArr[] =
    {
        300, 300,
    };
    
    GLfloat *attrP = attrArr;
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrP, GL_STATIC_DRAW);
    
    
    GLuint position = glGetAttribLocation(self.myProgram, "inVertex");
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    glDrawArrays(GL_POINTS, 0, 1);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
