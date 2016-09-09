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


#define ImgWidth                Screen_Width
#define ImgHeight               Screen_Height


#define CircleR         8

#define Distance        35


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
    
    __weak __typeof(self)weakSelf = self;
    self.addNewPoint = ^(CGPoint point){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        cv::Point point1 = cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight);
        cv::Point point2 = cv::Point(point.x / self.srcImageView.width * ImgWidth, point.y / self.srcImageView.heigth * ImgHeight);
        
        draw->drawLine(srcMat, point1, point2, 5);
        strongSelf.srcImageView.image = MatToUIImage(srcMat);
    };
    
    delete draw;
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
            
<<<<<<< HEAD
            
            pixel->drawCircle(srcMat, cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight), 30);
=======
//            pixel->drawCircle(srcMat, cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight), 30);
//            self.srcImageView.image = MatToUIImage(srcMat);
            

            cv::Point point1 = cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight);
            cv::Point point2 = cv::Point(self.lastPoint.x / self.srcImageView.width * ImgWidth, self.lastPoint.y / self.srcImageView.heigth * ImgHeight);
            draw->drawLine(srcMat, point1, point2, 8);
>>>>>>> 4776b27ee00e8a6064619aa5d9204981fddc666c
            self.srcImageView.image = MatToUIImage(srcMat);
            

        }
    }
    self.angle = angle;

}



<<<<<<< HEAD
- (void)dealloc
{
    delete pixel;
}

=======
>>>>>>> 4776b27ee00e8a6064619aa5d9204981fddc666c

@end
