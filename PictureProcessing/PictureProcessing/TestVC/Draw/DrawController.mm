//
//  DrawController.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/6.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "DrawController.h"
#import "CategoryHeader.h"
#import "TJPixel.hpp"
#import "MathFunc.h"


#define ImgWidth                Screen_Width * 3
#define ImgHeight               Screen_Height * 3


#define CircleR         8

#define Distance        50


@interface DrawController ()

@property (nonatomic, strong) NSMutableArray        *pointArrM;

@property (nonatomic, assign) CGPoint               currentPoint;

/** 角度 */
@property (nonatomic, assign) float                 angle;


@end

@implementation DrawController


Mat             srcMat;
TJPixel         *pixel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self pixelTest];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/** 图片像素操作 */
- (void)pixelTest {
    pixel = new TJPixel();
    
    
    srcMat = pixel->createPngImg(cv::Size(ImgWidth, ImgHeight));
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self.srcImageView];
    
    self.currentPoint = location;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.srcImageView];
    
    
    double angle = atan((location.y - self.currentPoint.y) / (location.x - self.currentPoint.x));
    CGFloat distance = hypot(fabs(location.y - self.currentPoint.y), fabs(location.x - self.currentPoint.x));
    
    if (distance < 2 * CircleR) {
        return;
    }
    if (fabs(self.angle - angle) < M_PI_4 && distance < Distance) {
        return;
    }else if (distance > Distance) {
        int count = distance / Distance;
        for (int i = 0; i < count; i++) {
            self.currentPoint = [MathFunc newPointWithLastLocation:self.currentPoint local:location distance:Distance];
            NSValue *value = [NSValue valueWithCGPoint:self.currentPoint];
            [self.pointArrM addObject:value];
            
            pixel->drawCircle(srcMat, cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight), 30);
            self.srcImageView.image = MatToUIImage(srcMat);
            
        }
    }
    self.angle = angle;
}

- (NSMutableArray *)pointArrM
{
    if (!_pointArrM) {
        _pointArrM = [NSMutableArray array];
    }
    return _pointArrM;
}



@end
