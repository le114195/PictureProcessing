//
//  TJOpenglesCurve.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/13.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesCurve.h"
#import <GLKit/GLKit.h>
#import "OpenglTool.h"
#import "TJ_DrawTool.h"

NSString *const TJ_CurveVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_CurveFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D colorMap;
 uniform highp float aspectRatio;
 uniform highp float rateX;
 uniform highp float rateY;
 uniform highp float radius;
 
 uniform highp vec2 center;
 
 void main()
 {
//     highp vec2 textureCoordinateToUse = vec2(varyTextCoord.x, (varyTextCoord.y - center.y) * aspectRatio + center.y);
//     highp float dist = distance(center, textureCoordinateToUse);
//     textureCoordinateToUse = varyTextCoord;
//     if (dist < radius){
//         textureCoordinateToUse -= center;
//         
//         highp float percent = (radius - dist) / radius;
//         percent = percent;
//         
//         textureCoordinateToUse = vec2(textureCoordinateToUse.x + rateX * percent * 0.01, textureCoordinateToUse.y + rateY * percent * 0.01);
//
//         textureCoordinateToUse += center;
//     }
     gl_FragColor = texture2D(colorMap, varyTextCoord);
 }

 );


@interface TJOpenglesCurve ()

@property (nonatomic, strong) UIImage           *image;

@property (nonatomic , strong) EAGLContext* myContext;
@property (nonatomic , strong) CAEAGLLayer* myEagLayer;
@property (nonatomic , assign) GLuint       myProgram;
@property (nonatomic , assign) GLuint       myVertices;

@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;


@property (nonatomic, assign) CGFloat       ImgWidth;
@property (nonatomic, assign) CGFloat       ImgHeight;


@property (nonatomic, strong) UIImage       *renderImg;


@property (nonatomic, assign) CGPoint       locationPoint;
@property (nonatomic, assign) CGPoint       previousPoint;


@end




@implementation TJOpenglesCurve
{
    CGImageRef      rfImage;
    BOOL            firstTouch;
    CGPoint         _location;
    CGPoint         _previousLocation;
    
    GLint           rectW;
    GLint           rectH;
    GLint           rectLength;
    
    GLfloat         *attrArr;
    
    GLint           *indices;
    
}



+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.image = image;
        self.renderImg = image;
        
        rectW = 5;
        rectH = 5;
        
        rectLength = rectW * rectH;
        GLfloat rate = 2.0;
        attrArr = (GLfloat *)malloc(5 * rectLength * sizeof(GLfloat));
        for (int i = 0; i < rectLength; i++) {
            attrArr[i * 5] = -1 + rate * (i%rectW)/rectW;
            attrArr[i * 5 + 1] = 1 - (i/rectW) * rate;
            attrArr[i * 5 + 2] = 0;
            attrArr[i * 5 + 3] = (i%2) * rate * 0.5;
            attrArr[i * 5 + 4] = (i/2) * rate * 0.5;
        }
        
        indices = (GLint *)malloc((rectW - 1) * (rectH - 1) * 2 * 3 * sizeof(GLint));
        
        for (int i = 0; i < (rectW - 1) * (rectH - 1); i++) {
            indices[i * 6] = i / (rectW - 1) * rectW + i%(rectW - 1);
            indices[i * 6 + 1] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1);
            indices[i * 6 + 2] = i / (rectW - 1) * rectW + rectW +  + i%(rectW - 1) + 1;
            
            indices[i * 6 + 3] = i / (rectW - 1) * rectW + i%(rectW - 1);
            indices[i * 6 + 4] = i / (rectW - 1) * rectW + i%(rectW - 1) + 1;
            indices[i * 6 + 5] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1) + 1;
        }
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
    [self setupLayer];
    
    [self setupContext];
    
    [self destoryRenderAndFrameBuffer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    [self setupShaders];
    
    [self render];
    
    
}


- (void)setupShaders
{
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    self.ImgWidth = self.frame.size.width * scale;
    self.ImgHeight = self.frame.size.height * scale;
    glViewport(0, 0, self.frame.size.width * scale, self.frame.size.height * scale);
    
    
    if (self.myProgram) {
        glDeleteProgram(self.myProgram);
        self.myProgram = 0;
    }
    self.myProgram = [self loadShaders:TJ_CurveVertexShaderString frag:TJ_CurveFragmentShaderString];
    
    glLinkProgram(self.myProgram);
    GLint linkSuccess;
    glGetProgramiv(self.myProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(self.myProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"error%@", messageString);
        
        return ;
    }
    else {
        glUseProgram(self.myProgram);
    }
}

- (void)render {

    GLuint aspectRatioLocation = glGetUniformLocation(self.myProgram, "aspectRatio");
    glUniform1f(aspectRatioLocation, self.ImgHeight/self.ImgWidth);
    
    GLuint radiusLocation = glGetUniformLocation(self.myProgram, "radius");
    glUniform1f(radiusLocation, 0.25);
    
    
    float rateX = 0, rateY = 0;
    if (self.previousPoint.y == self.locationPoint.y) {
        if (self.previousPoint.x > self.locationPoint.x) {
            rateX = 1;
        }else {
            rateX = -1;
        }
    }else {
        float dis = sqrt((self.locationPoint.x - self.previousPoint.x)*(self.locationPoint.x - self.previousPoint.x) + (self.locationPoint.y - self.previousPoint.y)*(self.locationPoint.y - self.previousPoint.y));
        rateX = (self.previousPoint.x - self.locationPoint.x)/dis;
        rateY = (self.previousPoint.y - self.locationPoint.y)/dis;
    }
    
    GLuint rateXLocation = glGetUniformLocation(self.myProgram, "rateX");
    glUniform1f(rateXLocation, rateX);
    
    GLuint rateYLocation = glGetUniformLocation(self.myProgram, "rateY");
    glUniform1f(rateYLocation, rateY);
    
    GLuint previousLocationLocation = glGetUniformLocation(self.myProgram, "center");
    GLfloat positionArray[2];
    positionArray[0] = self.previousPoint.x;
    positionArray[1] = self.previousPoint.y;
    glUniform2fv(previousLocationLocation, 1, positionArray);
    
    
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
    
    
    for (int i = 0; i < rectLength; i++) {
        NSLog(@"%f, %f, %f, %f, %f", attrArr[i * 5], attrArr[i * 5 + 1], attrArr[i * 5 + 2], attrArr[i * 5 + 3], attrArr[i * 5 + 4]);
    }
    
    
    
    
    [self setupTexture:self.renderImg];
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, indices);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
    
    self.renderImg = [OpenglTool tj_glTOImageWithSize:CGSizeMake(self.ImgWidth, self.ImgHeight)];
}

- (BOOL)validate:(GLuint)_programId {
    GLint logLength, status;
    
    glValidateProgram(_programId);
    glGetProgramiv(_programId, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(_programId, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(_programId, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}



- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    GLuint verShader, fragShader;
    GLint program = glCreateProgram();
    
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);
    
    
    // Free up no longer needed shader resources
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    return program;
}

- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    const GLchar* source = (GLchar *)[file UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
}



- (void)setupLayer
{
    self.myEagLayer = (CAEAGLLayer*) self.layer;
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    self.myEagLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
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

- (void)setupRenderBuffer {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
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





// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*            touch = [[event touchesForView:self] anyObject];
    firstTouch = YES;
    // Convert touch point from UIView referential to OpenGL one (upside-down flip)
    _location = [touch locationInView:self];
    
    self.previousPoint = CGPointMake(_location.x/self.bounds.size.width, _location.y/self.bounds.size.height);
    
    [self render];
    
    
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*			touch = [[event touchesForView:self] anyObject];
    
    CGPoint location = [touch locationInView:self];
    self.locationPoint = CGPointMake(location.x/self.bounds.size.width, location.y/self.bounds.size.height);
    
    if (sqrt((location.x - _location.x)*(location.x - _location.x) + (location.y - _location.y)*(location.y - _location.y)) < 5) {
        return;
    }
    self.previousPoint = CGPointMake(_location.x/self.bounds.size.width, _location.y/self.bounds.size.height);
    _location = location;
//    [self render];
}





@end
