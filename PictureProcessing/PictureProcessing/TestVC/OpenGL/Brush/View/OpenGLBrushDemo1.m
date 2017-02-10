//
//  OpenGLBrushDemo1.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/10.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenGLBrushDemo1.h"
#import "TJ_DrawTool.h"
#import "TJ_DrawTool_C.h"


NSString *const TJ_Brush1VertexShaderString = TJ_STRING_ES
(
 attribute vec4 inVertex;
 
 uniform mat4 MVP;
 uniform float pointSize;
 uniform lowp vec4 vertexColor;
 
 varying lowp vec4 color;
 
 void main()
 {
     gl_Position = MVP * inVertex;
     gl_PointSize = pointSize;
     color = vertexColor;
 }
 );


NSString *const TJ_Brush1FragmentShaderString = TJ_STRING_ES
(
 uniform sampler2D texture;
 varying lowp vec4 color;
 
 void main()
 {
     gl_FragColor = color * texture2D(texture, gl_PointCoord);
 }
 );

@implementation OpenGLBrushDemo1
{
    GLfloat brushTextureW;
    CGPoint location;
    BOOL    firstTouch;
    CGFloat ConstDistance;
}


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        VertexShaderString = TJ_Brush1VertexShaderString;
        FragmentShaderString = TJ_Brush1FragmentShaderString;
        
        ConstDistance = 10;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self setupTexture];
    [self setupShaderParameters];
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
    brushColor[1] = 1.0 * brushOpacity;
    brushColor[2] = 1.0 * brushOpacity;
    brushColor[3] = brushOpacity;
    
    glUniform4fv(glGetUniformLocation(self.myProgram, "vertexColor"), 1, brushColor);
}


#pragma mark - 获取移动轨迹
- (void)renderLineFromPointArr:(NSArray *)pointArr
{
    CGRect				bounds = [self bounds];
    static GLfloat*		vertexBuffer = NULL;
    static NSUInteger	vertexMax = 64;
    NSUInteger			vertexCount = 0;
    
    // Allocate vertex array buffer
    if(vertexBuffer == NULL)
        vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
    
    // Convert locations from Points to Pixels
    
    CGFloat scale = self.contentScaleFactor;
    for (NSValue *value in pointArr) {
        CGPoint point = [value CGPointValue];
        point.y = bounds.size.height - point.y;
        
        point.x *= scale;
        point.y *= scale;
        
        vertexBuffer[2*vertexCount + 0] = point.x;
        vertexBuffer[2*vertexCount + 1] = point.y;
        
        vertexCount++;
    }
    
    // Load data to the Vertex Buffer Object
    GLuint  vertexBufferID;
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, vertexCount*2*sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    

    GLuint position = glGetAttribLocation(self.myProgram, "inVertex");
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}



// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*            touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    location = [touch locationInView:self];
    
    [self renderLineFromPointArr:[NSArray arrayWithObject:[NSValue valueWithCGPoint:location]]];
    
    [TJ_DrawTool constDisDraw:location dis:ConstDistance isStartMove:YES completion:nil];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*			touch = [[event touchesForView:self] anyObject];
    location = [touch locationInView:self];
    
    if (firstTouch) {
        firstTouch = NO;
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [TJ_DrawTool constDisDraw:location dis:ConstDistance isStartMove:NO completion:^(NSArray *array) {
        [weakSelf renderLineFromPointArr:array];
    }];
}




@end
