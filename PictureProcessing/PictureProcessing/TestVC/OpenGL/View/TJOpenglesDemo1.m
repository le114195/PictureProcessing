//
//  TJOpenglesDemo1.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesDemo1.h"
#import "TJ_GLProgram.h"



NSString *const TJ_TriangleVertexShaderString = TJ_STRING_ES
(
 
 attribute vec4 Position;
 void main(void) {
     gl_Position = Position;
 }
 
 );


NSString *const TJ_TriangleFragmentShaderString = TJ_STRING_ES
(
 
 precision mediump float;
 void main(void) {
     gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
 }
 
 );


@interface TJOpenglesDemo1 ()

@property (nonatomic , strong) EAGLContext* myContext;
@property (nonatomic , strong) CAEAGLLayer* myEagLayer;
@property (nonatomic , assign) GLuint       myProgram;


@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;
@property (nonatomic , strong) TJ_GLProgram* mProgram;

@end


@implementation TJOpenglesDemo1

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        
        [self customInit];
    }
    
    return self;
}


- (void)layoutSubviews {
    [self destoryRenderAndFrameBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self render];
}

- (void)customInit {
    [self setupLayer];
    [self setupContext];
    [self setupProgram];
}

- (void)render {
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawArrays(GL_LINE_LOOP, 0, 3);
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupProgram {
    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
    
    self.mProgram = [[TJ_GLProgram alloc] initWithVertexShaderString:TJ_TriangleVertexShaderString fragmentShaderString:TJ_TriangleFragmentShaderString];
    
    
    if (![self.mProgram link]) {
        NSLog(@"link error");
    }
    
    [self.mProgram addAttribute:@"Position"];
    [self.mProgram use];
    
    
    GLuint positionSlot = [self.mProgram attributeIndex:@"Position"];
    
    //坐标数组
    GLfloat attrArr[] =
    {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    
    GLuint  vertexBuffer;
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(positionSlot);
    
    glLineWidth(10.0);
    
}

- (void)setupLayer
{
    self.myEagLayer = (CAEAGLLayer*) self.layer;
    //设置放大倍数
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    self.myEagLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}


- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    self.myContext = context;
}

- (void)setupRenderBuffer {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    // 为 颜色缓冲区 分配存储空间
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}


- (void)setupFrameBuffer {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorRenderBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, self.myColorRenderBuffer);

}


- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;
}



#pragma mark - test
 
 
@end
