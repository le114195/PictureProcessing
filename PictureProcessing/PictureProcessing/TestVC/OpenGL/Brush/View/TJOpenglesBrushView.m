//
//  TJOpenglesBrushView.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesBrushView.h"
#import "TJ_GLProgram.h"
#import <GLKit/GLKit.h>
#import "TJ_DrawTool.h"

#import "TJ_DrawTool_C.h"

#define kBrushOpacity		(1.0 / 3.0)
#define kBrushPixelStep		30
#define kBrushScale			2


#define ConstDistance           10



NSString *const TJ_BrushVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_BrushFragmentShaderString = TJ_STRING_ES
(
     uniform sampler2D texture;
     varying lowp vec4 color;

     void main()
     {
        gl_FragColor = color * texture2D(texture, gl_PointCoord);
     }
);


enum {
    ATTRIB_VERTEX,
    NUM_ATTRIBS
};


// Texture
typedef struct {
    GLuint id;
    GLsizei width, height;
} textureInfo_t;

@implementation LYPoint

- (instancetype)initWithCGPoint:(CGPoint)point {
    self = [super init];
    
    if (self) {
        self.mX = [NSNumber numberWithDouble:point.x];
        self.mY = [NSNumber numberWithDouble:point.y];
    }
    return self;
}
@end



@interface TJOpenglesBrushView ()
{
    // The pixel dimensions of the backbuffer
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    // OpenGL names for the renderbuffer and framebuffers used to render to this view
    GLuint viewRenderbuffer, viewFramebuffer;
    

    GLuint depthRenderbuffer;
    
    textureInfo_t brushTexture;     // brush texture
    GLfloat brushColor[4];          // brush color
    
    Boolean	firstTouch;
    Boolean needsErase;
    
    // Shader objects
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint shaderProgram;
    
    // Buffer Objects
    GLuint vboId;
    
    BOOL initialized;
    
    TJ_Point testPoint;
    
}

@property (nonatomic, strong) TJ_GLProgram      *mProgram;


@property (nonatomic, assign) CGPoint               previousPoint;

/** 角度 */
@property (nonatomic, assign) float                 angle;


@property (nonatomic, strong) NSMutableArray        *pointArrM;

@end


@implementation TJOpenglesBrushView

@synthesize  location;
@synthesize  previousLocation;



+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            return nil;
        }
        
        // Set the view's scale factor as you wish
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        // Make sure to start with a cleared buffer
        needsErase = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    
    if (!initialized) {
        initialized = [self initGL];
    }
    else {
        [self resizeFromLayer:(CAEAGLLayer*)self.layer];
    }
    
    // Clear the framebuffer the first time it is allocated
    if (needsErase) {
        [self erase];
        needsErase = NO;
    }
}

- (void)setupShaders
{
    self.mProgram = [[TJ_GLProgram alloc] initWithVertexShaderString:TJ_BrushVertexShaderString fragmentShaderString:TJ_BrushFragmentShaderString];
    
    if (![self.mProgram link]) {
        return;
    }
    
    [self.mProgram validate];
    
    // Set constant/initalize uniforms
    [self.mProgram use];
    
    // the brush texture will be bound to texture unit 0
    glUniform1i([self.mProgram uniformIndex:@"texture"], 0);
    
    // viewing matrices
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, backingWidth, 0, backingHeight, -1, 1);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUniformMatrix4fv([self.mProgram uniformIndex:@"MVP"], 1, GL_FALSE, MVPMatrix.m);
    
    // point size
    glUniform1f([self.mProgram uniformIndex:@"pointSize"], brushTexture.width / kBrushScale);
    
    // initialize brush color
    glUniform4fv([self.mProgram uniformIndex:@"vertexColor"], 1, brushColor);
}

// Create a texture from an image
- (textureInfo_t)textureFromName:(NSString *)name
{
    CGImageRef		brushImage;
    CGContextRef	brushContext;
    GLubyte			*brushData;
    size_t			width, height;
    GLuint          texId;
    textureInfo_t   texture;
    
    // First create a UIImage object from the data in a image file, and then extract the Core Graphics image
    
    brushImage = [UIImage imageNamed:name].CGImage;
    
    // Get the width and height of the image
    width = CGImageGetWidth(brushImage);
    height = CGImageGetHeight(brushImage);
    
    // Make sure the image exists
    if(brushImage) {
        // Allocate  memory needed for the bitmap context
        brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        // Use  the bitmatp creation function provided by the Core Graphics framework.
        brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
        // After you create the context, you can draw the  image to the context.
        CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(brushContext);
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, &texId);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, texId);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
        // Release  the image data; it's no longer needed
        free(brushData);
        
        texture.id = texId;
        texture.width = (int)width;
        texture.height = (int)height;
    }
    
    return texture;
}

- (BOOL)initGL
{
    // Generate IDs for a framebuffer object and a color renderbuffer
    glGenFramebuffers(1, &viewFramebuffer);
    glGenRenderbuffers(1, &viewRenderbuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    // This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
    // allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    // Setup the view port in Pixels
    glViewport(0, 0, backingWidth, backingHeight);
    
    // Create a Vertex Buffer Object to hold our data
    glGenBuffers(1, &vboId);
    
    // Load the brush texture
    brushTexture = [self textureFromName:@"test128.png"];
    
    // Load shaders
    [self setupShaders];
    
    // Enable blending and set a blending function appropriate for premultiplied alpha pixel data
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    return YES;
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"Failed to make complete framebuffer objectz %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    [self.mProgram use];
    
    // Update projection matrix
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, backingWidth, 0, backingHeight, -1, 1);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity; // this sample uses a constant identity modelView matrix
    GLKMatrix4 MVPMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glUniformMatrix4fv([self.mProgram uniformIndex:@"MVP"], 1, GL_FALSE, MVPMatrix.m);
    
    // Update viewport
    glViewport(0, 0, backingWidth, backingHeight);
    
    return YES;
}



#pragma mark - 清空屏幕
- (void)erase
{
    [EAGLContext setCurrentContext:context];
    
    // Clear the buffer
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Display the buffer
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
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
    
    //glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    
    // Load data to the Vertex Buffer Object
    GLuint  vertexBufferID;
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, vertexCount*2*sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
    
    
    GLuint position = glGetAttribLocation([self.mProgram myProgram], "inVertex");
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    // Draw
    glDrawArrays(GL_POINTS, 0, (int)vertexCount);
    
    // Display the buffer
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
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



// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // If appropriate, add code necessary to save the state of the application.
    // This application is not saving state.
    NSLog(@"cancell");
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}



#pragma mark - 设置画笔颜色
- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    // Update the brush color
    brushColor[0] = red * kBrushOpacity;
    brushColor[1] = green * kBrushOpacity;
    brushColor[2] = blue * kBrushOpacity;
    brushColor[3] = kBrushOpacity;
    
    if (initialized) {
        [self.mProgram use];
        glUniform4fv([self.mProgram uniformIndex:@"vertexColor"], 1, brushColor);
    }
}



#pragma mark - 释放程序
- (void)dealloc
{
    // Destroy framebuffers and renderbuffers
    if (viewFramebuffer) {
        glDeleteFramebuffers(1, &viewFramebuffer);
        viewFramebuffer = 0;
    }
    if (viewRenderbuffer) {
        glDeleteRenderbuffers(1, &viewRenderbuffer);
        viewRenderbuffer = 0;
    }
    if (depthRenderbuffer)
    {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
    // texture
    if (brushTexture.id) {
        glDeleteTextures(1, &brushTexture.id);
        brushTexture.id = 0;
    }
    // vbo
    if (vboId) {
        glDeleteBuffers(1, &vboId);
        vboId = 0;
    }
    
    // tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
}


- (NSMutableArray *)pointArrM {
    
    if (!_pointArrM) {
        _pointArrM = [NSMutableArray array];
    }
    return _pointArrM;
}



@end
