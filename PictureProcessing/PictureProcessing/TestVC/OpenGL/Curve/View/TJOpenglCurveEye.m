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
 uniform sampler2D textureColor;
 void main()
 {
     gl_FragColor = texture2D(textureColor, varyTextCoord);
     
 }
 
 );


@interface TJOpenglCurveEye ()

@property (nonatomic, assign) CGPoint       eye_top;
@property (nonatomic, assign) CGPoint       eye_bottom;
@property (nonatomic, assign) CGPoint       eye_left_corner;
@property (nonatomic, assign) CGPoint       eye_right_corner;



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
    
    GLuint          textureID;
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
        
        rectW = 1000;
        rectH = rectW * (image.size.width / image.size.height);;
        
        rectLength = rectW * rectH;
        attrArr = (GLfloat *)malloc(5 * rectLength * sizeof(GLfloat));
        configure_attrArr(attrArr, rectW, rectH);
        
        
        indices = (GLint *)malloc((rectW - 1) * (rectH - 1) * 2 * 3 * sizeof(GLint));
        configure_indices(indices, rectW, rectH);
        
        
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
    
    [self setupTexture:self.renderImg];

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
    
    glGenTextures(1, &textureID);
    
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    
    
    //将纹理与片段着色器对应起来
    GLuint textureLocation = glGetUniformLocation(self.myProgram, "textureColor");
    glUniform1i(textureLocation, 0);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    
    
    free(spriteData);
    return 0;
}



- (void)render {
    
    [self resetAttr];
    
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
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0992.JPG" ofType:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:MG_LICENSE_KEY forKey:@"api_key"];
    [dict setValue:MG_LICENSE_SECRE forKey:@"api_secret"];
    [dict setValue:@1 forKey:@"return_landmark"];
    
    NSString *url = @"https://api.megvii.com/facepp/v3/detect";
    
    [TJURLSession postWithUrl:url parameters:dict paths:@[path] fieldName:@"image_file" completion:^(id responseObject, int status) {
        
        NSArray *array = [responseObject valueForKey:@"faces"];
        NSDictionary *face = [array firstObject];
        
        
        NSDictionary *landmark = [face valueForKey:@"landmark"];
        
        NSDictionary *left_eye_top = [landmark valueForKey:@"left_eye_top"];
        NSDictionary *left_eye_bottom = [landmark valueForKey:@"left_eye_bottom"];
        NSDictionary *left_eye_left_corner = [landmark valueForKey:@"left_eye_left_corner"];
        NSDictionary *left_eye_right_corner = [landmark valueForKey:@"left_eye_right_corner"];
        
        
        
        _eye_top = CGPointMake([[left_eye_top valueForKey:@"x"] floatValue], [[left_eye_top valueForKey:@"y"] floatValue]);
        _eye_bottom = CGPointMake([[left_eye_bottom valueForKey:@"x"] floatValue], [[left_eye_bottom valueForKey:@"y"] floatValue]);
        _eye_left_corner = CGPointMake([[left_eye_left_corner valueForKey:@"x"] floatValue], [[left_eye_left_corner valueForKey:@"y"] floatValue]);
        _eye_right_corner = CGPointMake([[left_eye_right_corner valueForKey:@"x"] floatValue], [[left_eye_right_corner valueForKey:@"y"] floatValue]);

        
        TJ_GLPoint gl_eye_top, gl_eye_bottom, gl_eye_left_corner, gl_eye_right_corner;
        gl_eye_top.x = _eye_top.x;
        gl_eye_top.y = _eye_top.y;
        
        gl_eye_bottom.x = _eye_bottom.x;
        gl_eye_bottom.y = _eye_bottom.y;
        
        gl_eye_left_corner.x = _eye_left_corner.x;
        gl_eye_left_corner.y = _eye_left_corner.y;
        
        gl_eye_right_corner.x = _eye_right_corner.x;
        gl_eye_right_corner.y = _eye_right_corner.y;
        
        tj_curve_eye(attrArr, rectLength, self.ImgWidth, self.ImgHeight, gl_eye_top, gl_eye_bottom, gl_eye_left_corner, gl_eye_right_corner);
        
        _eye_top = CGPointMake(_eye_top.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_top.y / self.ImgWidth * 2);
        _eye_bottom = CGPointMake(_eye_bottom.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_bottom.y / self.ImgWidth * 2);
        _eye_left_corner = CGPointMake(_eye_left_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_left_corner.y / self.ImgWidth * 2);
        _eye_right_corner = CGPointMake(_eye_right_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_right_corner.y / self.ImgWidth * 2);
        

        
        [self render];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getFaceFreature];
}


#pragma mark -- 眨眼睛算法









- (void)algorithm3
{
    CGFloat dist = sqrt((_eye_top.x - _eye_bottom.x)*(_eye_top.x - _eye_bottom.x) + (_eye_top.y - _eye_bottom.y)*(_eye_top.y - _eye_bottom.y));
    
    //直线方程：Ax + By + C = 0;方向向量_eye_left_corner指向_eye_right_corner
    CGFloat A, B, C;
    if (_eye_left_corner.x == _eye_right_corner.x) {
        A = 1;
        B = 0;
        C = -_eye_right_corner.x;
    }else {
        A = - (_eye_right_corner.y - _eye_left_corner.y) / (_eye_right_corner.x - _eye_left_corner.x);
        B = 1;
        C = - (_eye_right_corner.y + A * _eye_right_corner.x);
    }
    
    
    //直线2：-(1/A)x + By + C2 = 0; 经过点_eye_left_corner
    CGFloat C2 = -(_eye_left_corner.y - (1/A)*_eye_left_corner.x);
    
    //直线3：-(1/A)x + By + C3 = 0; 经过点_eye_right_corner
    CGFloat C3 = -(_eye_right_corner.y - (1/A)*_eye_right_corner.x);
    
    //直线4：-(1/A)x + By + C4 = 0; 经过点_eye_left_corner和_eye_right_corner的中点
    CGFloat C4 = -((_eye_left_corner.y + _eye_right_corner.y) * 0.5 -
                   (1/A)*(_eye_left_corner.x + _eye_right_corner.x) * 0.5);
    
    //_eye_top到直线一的距离
    CGFloat topDist = fabs(A*_eye_top.x + B*_eye_top.y + C) / sqrt(A * A + B * B);
    //_eye_bottom到直线二的距离
    CGFloat bottomDist = fabs(A*_eye_bottom.x + B*_eye_bottom.y + C) / sqrt(A * A + B * B);
    
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    
    CGFloat percent;
    CGFloat edgeRate;
    CGFloat direction;
    if (A > 0) {
        direction = 1;
    }else {
        direction = -1;
    }
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        CGFloat dist00 = fabs(A*x + B*y + C) / sqrt(A * A + B * B);
        
        if ((-(1/A) * x + B * y + C2)*(C2 - C3) >= 0 &&
            (-(1/A) * x + B * y + C3) * (C2 - C3) <= 0)
        {
            //点到直线四的距离
            CGFloat dist4 = fabs(-(1/A) * x + B * y + C4) / sqrt((1/A)*(1/A) + B * B);
            
            edgeRate = 1 - 2 * dist4 / sqrt((_eye_left_corner.x - _eye_right_corner.x)*(_eye_left_corner.x - _eye_right_corner.x) + (_eye_left_corner.y - _eye_right_corner.y)*(_eye_left_corner.y - _eye_right_corner.y));
            
            edgeRate = sqrt(edgeRate);
            edgeRate = sqrt(edgeRate);
            
            if (A < 0) {
                edgeRate = edgeRate * -1;
            }
            
            if (A*x + B*y + C > 0) {
                if (dist00 < topDist) {
                    attrArr[i * 5] -= edgeRate * dist00 * B / sqrt((1/A)*(1/A) + B*B) * direction;
                    attrArr[i * 5 + 1] -= edgeRate * dist00 * (1/A) / sqrt((1/A)*(1/A) + B*B) * direction;
                }else if (dist00 < dist + topDist - bottomDist) {
                    percent = topDist / dist00;

                    attrArr[i * 5] -= edgeRate * percent * topDist * B / sqrt((1/A)*(1/A) + B*B) * direction;
                    attrArr[i * 5 + 1] -= edgeRate * percent * topDist * (1/A) / sqrt((1/A)*(1/A) + B*B) * direction;
                }
            }else if (A*x + B*y + C < 0 && dist00 < bottomDist) {
                attrArr[i * 5] += dist00 * B / sqrt((1/A)*(1/A) + B*B) * direction;
                attrArr[i * 5 + 1] += dist00 * (1/A) / sqrt((1/A)*(1/A) + B*B) * direction;
            }
        }
        attrArr[i * 5 + 1] *= (1/aspectRatio);
    }
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    
}

- (void)algorithm2
{
    CGFloat dist = sqrt((_eye_top.x - _eye_bottom.x)*(_eye_top.x - _eye_bottom.x) + (_eye_top.y - _eye_bottom.y)*(_eye_top.y - _eye_bottom.y));
    
    //直线方程：Ax + By + C = 0;两个点_eye_left_corner，_eye_right_corner
    CGFloat A, B, C;
    if (_eye_left_corner.x == _eye_right_corner.x) {
        A = 1;
        B = 0;
        C = -_eye_right_corner.x;
    }else {
        A = - (_eye_right_corner.y - _eye_left_corner.y) / (_eye_right_corner.x - _eye_left_corner.x);
        B = 1;
        C = - (_eye_right_corner.y + A * _eye_right_corner.x);
    }
    
    //点到直线的距离：fabs(Ax0 + By0 + C) / sqrt(A * A + B * B);
    CGFloat topDist = fabs(A*_eye_top.x + B*_eye_top.y + C) / sqrt(A * A + B * B);
    CGFloat bottomDist = fabs(A*_eye_bottom.x + B*_eye_bottom.y + C) / sqrt(A * A + B * B);
    
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    
    CGFloat percent;
    CGFloat edgeRate;
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        CGFloat dist00 = fabs(A*x + B*y + C) / sqrt(A * A + B * B);
        
        edgeRate = 1 - 2 * fabs(x - (_eye_left_corner.x + _eye_right_corner.x) * 0.5) / fabs(_eye_right_corner.x - _eye_left_corner.x);
        edgeRate = sqrt(edgeRate);
        edgeRate = sqrt(edgeRate);
        
        if (x > MIN(_eye_left_corner.x, _eye_right_corner.x) &&
            x < MAX(_eye_left_corner.x, _eye_right_corner.x))
        {
            if (A*x + B*y + C > 0) {
                if (dist00 < topDist) {
                    attrArr[i * 5] -= edgeRate * dist00 * A / sqrt(A*A + B*B);
                    attrArr[i * 5 + 1] -= edgeRate * dist00 * B / sqrt(A*A + B*B);
                }else if (dist00 < dist + topDist - bottomDist) {
                    percent = topDist / dist00;
                    percent = percent;
                    attrArr[i * 5] -= edgeRate * percent * topDist * A / sqrt(A*A + B*B);
                    attrArr[i * 5 + 1] -= edgeRate * percent * topDist * B / sqrt(A*A + B*B);
                }
            }else if (A*x + B*y + C < 0 && dist00 < bottomDist) {
                attrArr[i * 5] -= dist00 * A / sqrt(A*A + B*B);
                attrArr[i * 5 + 1] -= dist00 * B / sqrt(A*A + B*B);
            }
        }
        attrArr[i * 5 + 1] *= (1/aspectRatio);
    }
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    
}



- (void)algorithm1
{

    CGFloat dist = sqrt((_eye_top.x - _eye_bottom.x)*(_eye_top.x - _eye_bottom.x) + (_eye_top.y - _eye_bottom.y)*(_eye_top.y - _eye_bottom.y));
    
    
    //直线方程：Ax + By + C = 0;两个点_eye_left_corner，_eye_right_corner
    CGFloat A, B, C;
    if (_eye_left_corner.x == _eye_right_corner.x) {
        A = 1;
        B = 0;
        C = -_eye_right_corner.x;
    }else {
        A = - (_eye_right_corner.y - _eye_left_corner.y) / (_eye_right_corner.x - _eye_left_corner.x);
        B = 1;
        C = - (_eye_right_corner.y + A * _eye_right_corner.x);
    }
    
    //点到直线的距离：fabs(Ax0 + By0 + C) / sqrt(A * A + B * B);
    CGFloat topDist = fabs(A*_eye_top.x + B*_eye_top.y + C) / sqrt(A * A + B * B);
    CGFloat bottomDist = fabs(A*_eye_bottom.x + B*_eye_bottom.y + C) / sqrt(A * A + B * B);

    CGFloat percent;
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        CGFloat dist00 = fabs(A*x + B*y + C) / sqrt(A * A + B * B);
        
        if (x > MIN(_eye_left_corner.x, _eye_right_corner.x) &&
            x < MAX(_eye_left_corner.x, _eye_right_corner.x))
        {
            if (A*x + B*y + C > 0) {
                if (dist00 < topDist) {
                    percent = 1 - 2 * fabs(x - (_eye_left_corner.x + _eye_right_corner.x) * 0.5) / fabs(_eye_right_corner.x - _eye_left_corner.x);
                    percent = sqrt(percent);
                    percent = sqrt(percent);
                    attrArr[i * 5] -= percent * dist00 * A / sqrt(A*A + B*B);
                    attrArr[i * 5 + 1] -= percent * dist00 * B / sqrt(A*A + B*B);
                }else if (dist00 < dist + topDist - bottomDist) {
                    percent = topDist / dist00;
                    percent = percent;
                    attrArr[i * 5] -= percent * topDist * A / sqrt(A*A + B*B);
                    attrArr[i * 5 + 1] -= percent * topDist * B / sqrt(A*A + B*B);
                }
            }else if (A*x + B*y + C < 0 && dist00 < bottomDist) {
                attrArr[i * 5] += dist00 * A / sqrt(A*A + B*B);
                attrArr[i * 5 + 1] += dist00 * B / sqrt(A*A + B*B);
            }
        }
        attrArr[i * 5 + 1] *= (1/aspectRatio);
    }
}


- (void)dealloc
{
    free(attrArr);
    free(indices);
}


@end
