//
//  TJOpenGL3View.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/19.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenGL3View.h"
#import <GLKit/GLKit.h>
#import "shaderUtil.h"
#import "fileUtil.h"
#import "debug.h"



#define kBrushOpacity		(1.0 / 3.0)
#define kBrushPixelStep		3
#define kBrushScale			2



//纹理
typedef struct {
    GLuint  textID;
    GLsizei width, height;
} textureInfo_t;



@interface TJOpenGL3View ()
{
    EAGLContext         *context;
    
    GLint               backingWidth, backingHeight;
    
    GLuint              viewRenderbuffer, viewFramebuffer;
    
    GLuint              depthRenderbuffer;
    
    GLfloat             brushColor[4];
    
    
    GLuint              vertexShader;
    GLuint              fragmentShader;
    GLuint              shaderProgram;
    
    GLuint              vboId;
    
    textureInfo_t       brushTexture;
    
    BOOL                initialized;
    
    
    BOOL            firstTouch;
    
    CGPoint         location;
    CGPoint         previousLocation;
    
    
}





@end



@interface TJOpenGL3View ()






@end



@implementation TJOpenGL3View

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            return nil;
        }
        // Set the view's scale factor as you wish
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    return self;
}





@end
