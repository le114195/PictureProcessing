//
//  TriangleTest.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/21.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TriangleTest.h"
#import <GLKit/GLKit.h>


NSString *const TJTriangleVertexShader = TJ_STRING_ES
(
 layout(location = 0) in vec4 vPosition;
 void main()
 {
     gl_Position = vPosition;
 }
);



NSString *const TJTringleFragmentShader = TJ_STRING_ES
(
 precision mediump float;
 out vec4 fragColor;
 void main()
 {
     fragColor = vec4(1.0, 0.0, 0.0, 1.0);
 }
);



typedef struct {
    
    GLuint  programObject;
    
} UserData;




@interface TriangleTest ()


@property (nonatomic, strong) EAGLContext       *myContext;
@property (nonatomic, strong) CAEAGLLayer       *myEagLayer;
@property (nonatomic, assign) GLuint            myProgram;



@end



@implementation TriangleTest


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        
        
        
        
    }
    return self;
}


- (void)setupLayer
{
    self.myEagLayer = (CAEAGLLayer *)self.layer;
    
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    self.myEagLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
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






@end
