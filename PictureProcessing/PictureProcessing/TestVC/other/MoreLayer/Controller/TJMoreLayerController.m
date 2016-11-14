//
//  TJMoreLayerController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJMoreLayerController.h"

@interface TJMoreLayerController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray            *ImgViewArrM;

@property (nonatomic, strong) UIImageView               *testImgView;

@property (nonatomic, assign) CGFloat                   angle;

@end

@implementation TJMoreLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    //缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    
    //旋转
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    
    //平移
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
    
    self.ImgViewArrM = [NSMutableArray array];
    
    self.testImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 70, 100)];
    [self.view addSubview:_testImgView];
    self.testImgView.backgroundColor = [UIColor redColor];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 手势

/** 缩放 */
- (void)pinchAction:(UIPinchGestureRecognizer *)pinchGesture
{
    UIView *view = self.testImgView;
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        pinchGesture.scale = 1;
    }
    
//    //缩放大小
//    CGFloat scale = [(NSNumber *)[view valueForKeyPath:@"layer.transform.scale"] floatValue];
//    NSLog(@"scale = %f", scale);
}

/** 旋转 */
- (void)rotateAction:(UIRotationGestureRecognizer *)rotateGesture
{
    UIView *view = self.testImgView;
    if (rotateGesture.state == UIGestureRecognizerStateBegan || rotateGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotateGesture.rotation);
        [rotateGesture setRotation:0];
    }
    
//    //旋转角度获取方式
//    CGFloat angle = [(NSNumber *)[view valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
//    NSLog(@"%f", angle);
    
}

/** 平移 */
- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    UIView *view = self.testImgView;
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
}


//同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}




@end
