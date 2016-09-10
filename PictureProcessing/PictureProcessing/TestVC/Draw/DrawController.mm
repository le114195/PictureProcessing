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
#import "Draw.hpp"


#define ImgWidth                Screen_Width * 5
#define ImgHeight               Screen_Height * 5


#define CircleR         3.5
#define Distance        30.0


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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self pixelTest];
    
    
    [self drawTest];
    
    
    NSLog(@"width = %f", ImgWidth);
    
    NSLog(@"height = %f", ImgHeight);
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)drawTest {
    draw = new TJDraw();
    
    
//    srcMat = draw->createPngImg(cv::Size(ImgWidth, ImgHeight));
    
    srcMat = draw->createOneGalleryimg(cv::Size(ImgWidth, ImgHeight));
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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    draw->clearPointVec();
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
            
            
            cv::Point polygonPoint = cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight);
            
            draw->drawPolygon(polygonPoint, srcMat, 16);
            
            cv::Point point = draw->newPoint(cv::Point(self.currentPoint.x, self.currentPoint.y), cv::Point(location.x, location.y), Distance);
            self.currentPoint = CGPointMake(point.x, point.y);
            
//            draw->drawCircleFill(srcMat, cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight), 20);
//            self.srcImageView.image = MatToUIImage(srcMat);
            
            
            cv::Point point1 = cv::Point(self.currentPoint.x / self.srcImageView.width * ImgWidth, self.currentPoint.y / self.srcImageView.heigth * ImgHeight);
            cv::Point point2 = cv::Point(self.lastPoint.x / self.srcImageView.width * ImgWidth, self.lastPoint.y / self.srcImageView.heigth * ImgHeight);
            draw->drawLine(srcMat, point1, point2, 16);
            self.srcImageView.image = MatToUIImage(srcMat);
            

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
