//
//  TJOpenglesCurveEyebrow.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/27.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesCurveEyebrow.h"
#import "TJ_Opengl_C.h"
#import "TJURLSession.h"


NSString *const TJ_EyebrowVertexShaderString = TJ_STRING_ES
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


NSString *const TJ_EyebrowFragmentShaderString = TJ_STRING_ES
(
 varying lowp vec2 varyTextCoord;
 uniform sampler2D colorMap;
 void main()
 {
     gl_FragColor = texture2D(colorMap, varyTextCoord);
 }
 
 );





@interface TJOpenglesCurveEyebrow ()


@property (nonatomic, assign) CGPoint       eyebrow_upper_middle;
@property (nonatomic, assign) CGPoint       eyebrow_lower_middle;


@property (nonatomic, assign) CGPoint       eyebrow_left_corner;
@property (nonatomic, assign) CGPoint       eyebrow_right_corner;

@property (nonatomic, assign) CGPoint       right_eyebrow_left_corner;

/** 眼睛的顶部 */
@property (nonatomic, assign) CGPoint       eye_top;

/** 左眼：左眼角 */
@property (nonatomic, assign) CGPoint       eye_left_corner;

/** 左眼：右眼角 */
@property (nonatomic, assign) CGPoint       eye_right_corner;



@property (nonatomic, assign) CGFloat       move_dist;


@end



@implementation TJOpenglesCurveEyebrow
{
    CGImageRef      rfImage;
    
    CGPoint         previousLocation;
    
    GLint           rectW;
    GLint           rectH;
    GLint           rectLength;
    
    GLfloat         *attrArr;
    
    GLint           *indices;
    
    GLfloat         aspectRatio;
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
        
        VertexShaderString = TJ_EyebrowVertexShaderString;
        FragmentShaderString = TJ_EyebrowFragmentShaderString;
        
        
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



- (void)render {
    
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
    
    
    [self setupTexture:self.renderImg];
    
    glClearColor(0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glDrawElements(GL_TRIANGLES, (rectW - 1)*(rectH - 1) * 6, GL_UNSIGNED_INT, indices);
    
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
    
    //        self.renderImg = [OpenglTool tj_glTOImageWithSize:CGSizeMake(self.ImgWidth, self.ImgHeight)];
}


- (void)getFaceFreature
{
    
    
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    //sj_20160705_14.JPG
    //sj_20160705_26.JPG
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_26.JPG" ofType:nil];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:MG_LICENSE_KEY forKey:@"api_key"];
    [dict setValue:MG_LICENSE_SECRE forKey:@"api_secret"];
    [dict setValue:@1 forKey:@"return_landmark"];
    
    NSString *url = @"https://api.megvii.com/facepp/v3/detect";
    
    [TJURLSession postWithUrl:url parameters:dict paths:@[path] fieldName:@"image_file" completion:^(id responseObject, int status) {
        
        NSArray *array = [responseObject valueForKey:@"faces"];
        NSDictionary *face = [array firstObject];
        
        
        NSDictionary *landmark = [face valueForKey:@"landmark"];
        
        NSDictionary *left_eyebrow_upper_middle = [landmark valueForKey:@"left_eyebrow_upper_middle"];
        NSDictionary *left_eyebrow_lower_middle = [landmark valueForKey:@"left_eyebrow_lower_middle"];
        
        NSDictionary *left_eyebrow_left_corner = [landmark valueForKey:@"left_eyebrow_left_corner"];
        NSDictionary *left_eyebrow_right_corner = [landmark valueForKey:@"left_eyebrow_right_corner"];
        
        NSDictionary *right_eyebrow_left_corner_dict = [landmark valueForKey:@"right_eyebrow_left_corner"];
        
        NSDictionary *left_eye_top = [landmark valueForKey:@"left_eye_top"];
        NSDictionary *left_eye_left_corner = [landmark valueForKey:@"left_eye_left_corner"];
        NSDictionary *left_eye_right_corner = [landmark valueForKey:@"left_eye_right_corner"];
        
        
        _eyebrow_upper_middle = CGPointMake([[left_eyebrow_upper_middle valueForKey:@"x"] floatValue], [[left_eyebrow_upper_middle valueForKey:@"y"] floatValue]);
        _eyebrow_lower_middle = CGPointMake([[left_eyebrow_lower_middle valueForKey:@"x"] floatValue], [[left_eyebrow_lower_middle valueForKey:@"y"] floatValue]);
        
        _eyebrow_left_corner = CGPointMake([[left_eyebrow_left_corner valueForKey:@"x"] floatValue], [[left_eyebrow_left_corner valueForKey:@"y"] floatValue]);
        _eyebrow_right_corner = CGPointMake([[left_eyebrow_right_corner valueForKey:@"x"] floatValue], [[left_eyebrow_right_corner valueForKey:@"y"] floatValue]);
        
        _right_eyebrow_left_corner = CGPointMake([[right_eyebrow_left_corner_dict valueForKey:@"x"] floatValue], [[right_eyebrow_left_corner_dict valueForKey:@"y"] floatValue]);
        
        _eye_top = CGPointMake([[left_eye_top valueForKey:@"x"] floatValue], [[left_eye_top valueForKey:@"y"] floatValue]);
        _eye_left_corner = CGPointMake([[left_eye_left_corner valueForKey:@"x"] floatValue], [[left_eye_left_corner valueForKey:@"y"] floatValue]);
        _eye_right_corner = CGPointMake([[left_eye_right_corner valueForKey:@"x"] floatValue], [[left_eye_right_corner valueForKey:@"y"] floatValue]);
        
        
        TJ_GLPoint tj_eye_top, tj_eyebrow_upper_middle, tj_eyebrow_lower_middle, tj_eyebrow_left_corner, tj_eyebrow_right_corner;
        
        tj_eye_top.x = _eye_top.x;
        tj_eye_top.y = _eye_top.y;
        
        tj_eyebrow_upper_middle.x = _eyebrow_upper_middle.x;
        tj_eyebrow_upper_middle.y = _eyebrow_upper_middle.y;
        
        tj_eyebrow_lower_middle.x = _eyebrow_lower_middle.x;
        tj_eyebrow_lower_middle.y = _eyebrow_lower_middle.y;
        
        tj_eyebrow_left_corner.x = _eyebrow_left_corner.x;
        tj_eyebrow_left_corner.y = _eyebrow_left_corner.y;
        
        tj_eyebrow_right_corner.x = _eyebrow_right_corner.x;
        tj_eyebrow_right_corner.y = _eyebrow_right_corner.y;
        
        tj_curve_eyebrow(attrArr, rectLength, self.ImgWidth, self.ImgHeight, tj_eye_top, tj_eyebrow_upper_middle, tj_eyebrow_lower_middle, tj_eyebrow_left_corner, tj_eyebrow_right_corner);
        
        
//        
//        _eyebrow_upper_middle = CGPointMake(_eyebrow_upper_middle.x / self.ImgWidth * 2 - 1, aspectRatio - _eyebrow_upper_middle.y / self.ImgWidth * 2);
//        _eyebrow_lower_middle = CGPointMake(_eyebrow_lower_middle.x / self.ImgWidth * 2 - 1, aspectRatio - _eyebrow_lower_middle.y / self.ImgWidth * 2);
//        
//        _eyebrow_left_corner = CGPointMake(_eyebrow_left_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eyebrow_left_corner.y / self.ImgWidth * 2);
//        _eyebrow_right_corner = CGPointMake(_eyebrow_right_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eyebrow_right_corner.y / self.ImgWidth * 2);
//        
//        _right_eyebrow_left_corner = CGPointMake(_right_eyebrow_left_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _right_eyebrow_left_corner.y / self.ImgWidth * 2);
//        
//        _eye_top = CGPointMake(_eye_top.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_top.y / self.ImgWidth * 2);
//        _eye_left_corner = CGPointMake(_eye_left_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_left_corner.y / self.ImgWidth * 2);
//        _eye_right_corner = CGPointMake(_eye_right_corner.x / self.ImgWidth * 2 - 1, aspectRatio - _eye_right_corner.y / self.ImgWidth * 2);
//        
//        
//        self.move_dist = sqrt((_eyebrow_left_corner.x - _eyebrow_right_corner.x)*(_eyebrow_left_corner.x - _eyebrow_right_corner.x) + (_eyebrow_left_corner.y - _eyebrow_right_corner.y)*(_eyebrow_left_corner.y - _eyebrow_right_corner.y)) * 0.2;
//        
//        
//        [self algorithm3];
        
        [self render];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self getFaceFreature];
}



- (void)algorithm3
{
    //直线：Ax + By + C = 0;
    //方向：_eye_left_corner指向_eye_right_corner
    //经过点_eye_top与_eyebrow_lower_middle的中点
    CGPoint point0 = CGPointMake((_eye_top.x + _eyebrow_lower_middle.x) * 0.5, (_eye_top.y + _eyebrow_lower_middle.y) * 0.5);
    CGFloat A, B, C;
    if (_eyebrow_left_corner.x == _eyebrow_right_corner.x) {
        A = 1;
        B = 0;
        C = -point0.x;
    }else {
        A = - (_eyebrow_left_corner.y - _eyebrow_right_corner.y) / (_eyebrow_left_corner.x - _eyebrow_right_corner.x);
        B = 1;
        C = - (point0.y + A * point0.x);
    }

    
    //直线2：Ax + By + C2 = 0; 经过点_eyebrow_right_corner
    CGFloat C2 = -(_eyebrow_right_corner.y + A*_eyebrow_right_corner.x);
    
    //直线3：-(1/A)x + By + C3 = 0; 经过点_eyebrow_left_corner 朝(-A, 1)的反方向移动0.1*self.move_dist
    CGFloat C3 = -(_eyebrow_left_corner.y - (1/A)*_eyebrow_left_corner.x);
    
    //直线4：-(1/A)x + By + C4 = 0; 经过点_eyebrow_right_corner和_right_eyebrow_left_corner的中点
    CGPoint point4 = CGPointMake(_eyebrow_right_corner.x + 0.2 * (_eyebrow_right_corner.x - _eyebrow_left_corner.x),
                                 _eyebrow_right_corner.y + 0.2 * (_eyebrow_right_corner.y - _eyebrow_left_corner.y));
    CGFloat C4 = -(point4.y - (1/A)*point4.x);
    
    
    CGFloat move_direction;
    
    if (A > 0) {
        move_direction = 1;
    }else {
        move_direction = -1;
    }
    
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        
        //点到直线1的距离
        CGFloat dist00 = fabs(A*x + B*y + C2) / sqrt(A*A + B*B);
        
        //眉毛的最左边到眉毛的最右边的距离
        CGFloat totalDist = sqrt(2) * sqrt((_eyebrow_left_corner.x - _eyebrow_right_corner.x)*(_eyebrow_left_corner.x - _eyebrow_right_corner.x) + (_eyebrow_left_corner.y - _eyebrow_right_corner.y)*(_eyebrow_left_corner.y - _eyebrow_right_corner.y));
        CGFloat dist11 = sqrt((x - _eyebrow_right_corner.x)*(x - _eyebrow_right_corner.x) + (y - _eyebrow_right_corner.y)*(y - _eyebrow_right_corner.y));
        
        CGFloat percent = (self.move_dist * 3 - dist00) / (self.move_dist * 3);
        if (percent < 0) {
            percent = 0;
        }
        percent = sqrt(percent);
        
        CGFloat percent2 =(totalDist - dist11) / totalDist;
        if (percent2 < 0) {
            percent2 = 0;
        }
        
        
        if ((A * x + B * y + C)*(C - C2) > 0 &&
            (-(1/A) * x + B * y + C3)*(C3 - C4) > 0 &&
            (-(1/A) * x + B * y + C4) * (C3 - C4) < 0 &&
            dist00 < self.move_dist * 3)
        {
            if (dist00 < sqrt((_eyebrow_upper_middle.x - _eyebrow_lower_middle.x)*(_eyebrow_upper_middle.x - _eyebrow_lower_middle.x) + (_eyebrow_upper_middle.y - _eyebrow_lower_middle.y)*(_eyebrow_upper_middle.y - _eyebrow_lower_middle.y))) {
                attrArr[i * 5] += percent2 * self.move_dist * B / sqrt((1/A) * (1/A) + B * B) * move_direction;
                attrArr[i * 5 + 1] += percent2 * self.move_dist * (B/A) / sqrt((1/A) * (1/A) + B * B) * move_direction;
                
            }else {
                attrArr[i * 5] += percent2 * percent * self.move_dist * B / sqrt((1/A) * (1/A) + B * B) * move_direction;
                attrArr[i * 5 + 1] += percent2 * percent * self.move_dist * (1/A) / sqrt((1/A) * (1/A) + B * B) * move_direction;
            }
        }
        attrArr[i * 5 + 1] *= (1 / aspectRatio);
    }
    
}


- (void)algorithm2
{
    //直线：Ax + By + C = 0;
    //方向：_eye_left_corner指向_eye_right_corner
    //经过点_eye_top与_eyebrow_lower_middle的中点
    CGPoint point0 = CGPointMake((_eye_top.x + _eyebrow_lower_middle.x) * 0.5, (_eye_top.y + _eyebrow_lower_middle.y) * 0.5);
    CGFloat A, B, C;
    if (_eye_left_corner.x == _eye_right_corner.x) {
        A = 1;
        B = 0;
        C = -point0.x;
    }else {
        A = - (_eye_left_corner.y - _eye_right_corner.y) / (_eye_left_corner.x - _eye_right_corner.x);
        B = 1;
        C = - (point0.y + A * point0.x);
    }
    
    //直线2：Ax + By + C2 = 0; 经过点_eyebrow_right_corner
    CGFloat C2 = -(_eyebrow_right_corner.y + A*_eyebrow_right_corner.x);
    
    //直线3：-(1/A)x + By + C3 = 0; 经过点_eyebrow_left_corner 朝(-A, 1)的反方向移动0.1*self.move_dist
    CGFloat C3 = -(_eyebrow_left_corner.y - (1/A)*_eyebrow_left_corner.x);
    
    //直线4：-(1/A)x + By + C4 = 0; 经过点_eyebrow_right_corner和_right_eyebrow_left_corner的中点
    CGPoint point4 = CGPointMake(_eyebrow_right_corner.x + 0.3 * (_eye_right_corner.x - _eye_left_corner.x),
                                 _eyebrow_right_corner.y + 0.3 * (_eye_right_corner.y - _eye_left_corner.y));
    CGFloat C4 = -(point4.y - (1/A)*point4.x);

    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        
        //点到直线1的距离
        CGFloat dist00 = fabs(A*x + B*y + C2) / sqrt(A*A + B*B);
        
        //眉毛的最左边到眉毛的最右边的距离
        CGFloat totalDist = sqrt(2) * sqrt((_eyebrow_left_corner.x - _eyebrow_right_corner.x)*(_eyebrow_left_corner.x - _eyebrow_right_corner.x) + (_eyebrow_left_corner.y - _eyebrow_right_corner.y)*(_eyebrow_left_corner.y - _eyebrow_right_corner.y));
        CGFloat dist11 = sqrt((x - _eyebrow_right_corner.x)*(x - _eyebrow_right_corner.x) + (y - _eyebrow_right_corner.y)*(y - _eyebrow_right_corner.y));
        
        CGFloat percent = (self.move_dist * 3 - dist00) / (self.move_dist * 3);
        if (percent < 0) {
            percent = 0;
        }
        percent = sqrt(percent);
        
        CGFloat percent2 =(totalDist - dist11) / totalDist;
        if (percent2 < 0) {
            percent2 = 0;
        }
        
        
        if ((A * x + B * y + C)*(C - C2) > 0 &&
            (-(1/A) * x + B * y + C3)*(C3 - C4) > 0 &&
            (-(1/A) * x + B * y + C4) * (C3 - C4) < 0 &&
            dist00 < self.move_dist * 3)
        {
            if (dist00 < sqrt((_eyebrow_upper_middle.x - _eyebrow_lower_middle.x)*(_eyebrow_upper_middle.x - _eyebrow_lower_middle.x) + (_eyebrow_upper_middle.y - _eyebrow_lower_middle.y)*(_eyebrow_upper_middle.y - _eyebrow_lower_middle.y))) {
                attrArr[i * 5] += percent2 * self.move_dist * B / sqrt((1/A) * (1/A) + B * B);
                attrArr[i * 5 + 1] += percent2 * self.move_dist * (B/A) / sqrt((1/A) * (1/A) + B * B);
            
            }else {
                attrArr[i * 5] += percent2 * percent * self.move_dist * B / sqrt((1/A) * (1/A) + B * B);
                attrArr[i * 5 + 1] += percent2 * percent * self.move_dist * (1/A) / sqrt((1/A) * (1/A) + B * B);
            }
        }
        attrArr[i * 5 + 1] *= (1 / aspectRatio);
    }
    
}




@end
