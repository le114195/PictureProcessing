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
#import "Draw.hpp"


#define ImgWidth                Screen_Width * 2
#define ImgHeight               Screen_Height * 2


#define CircleR         8

#define Distance        20


@interface DrawController ()

@property (nonatomic, strong) NSMutableArray        *pointArrM;

@property (nonatomic, assign) CGPoint               currentPoint;


@property (nonatomic, assign) CGPoint               lastPoint;

/** 角度 */
@property (nonatomic, assign) float                 angle;


@property (nonatomic, copy) void(^addNewPoint)(CGPoint newPoint);

@end

@implementation DrawController


Mat             srcMat;
TJPixel         *pixel;
TJDraw          *draw;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    [self pixelTest];
    
    
    [self drawTest];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)drawTest {
    draw = new TJDraw();
    srcMat = draw->createPngImg(cv::Size(ImgWidth, ImgHeight));
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
    
    
    [self constDistance:location];
}

- (NSMutableArray *)pointArrM
{
    if (!_pointArrM) {
        _pointArrM = [NSMutableArray array];
    }
    return _pointArrM;
}


/** 取出距离恒定的点 */
- (void)constDistance:(CGPoint)location
{
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
            
            self.lastPoint = self.currentPoint;
            self.currentPoint = [MathFunc newPointWithLastLocation:self.currentPoint local:location distance:Distance];
            
            
            draw->drawCircleFill(srcMat, cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight), 20);
            
            self.srcImageView.image = MatToUIImage(srcMat);
            
//            NSLog(@"%@%@", NSStringFromCGPoint(self.currentPoint), NSStringFromCGPoint(self.lastPoint));
//            
//            
//            cv::Point point1 = cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight);
//            cv::Point point2 = cv::Point(self.lastPoint.x / self.srcImageView.width * ImgWidth, self.lastPoint.y / self.srcImageView.heigth * ImgHeight);
//            draw->drawLine(srcMat, point1, point2, 8);
//            self.srcImageView.image = MatToUIImage(srcMat);
            

        }
    }
    self.angle = angle;

}



- (void)dealloc
{
    delete pixel;
    delete draw;
}

@end
