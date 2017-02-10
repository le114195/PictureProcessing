//
//  OpenGLBrushLine1.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/10.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenGLBrushLine1.h"


NSString *const TJ_Line1VertexShaderString = TJ_STRING_ES
(
 attribute vec4 position;
 
 void main()
 {
     gl_Position = position;
 }
 );

NSString *const TJ_Line1FragmentShaderString = TJ_STRING_ES
(
 void main()
 {
     gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
 }
 );

@implementation OpenGLBrushLine1

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        VertexShaderString = TJ_Line1VertexShaderString;
        FragmentShaderString = TJ_Line1FragmentShaderString;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self render];
}



- (void)render {
    
    
    glLineWidth(5.0);
    
    //坐标数组
    GLfloat attrArr[] =
    {
        0,      0,
        0.5,    0,
        -0.5,   0.5,
        -1.0,   0,
    };
    
    GLfloat *attrP = attrArr;
    
    GLuint  vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrP, GL_STATIC_DRAW);
    
    
    GLuint position = glGetAttribLocation(self.myProgram, "position");
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    glDrawArrays(GL_LINES, 0, 2);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}




@end
