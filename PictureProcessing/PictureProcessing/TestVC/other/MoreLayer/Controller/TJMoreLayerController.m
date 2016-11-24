//
//  TJMoreLayerController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJMoreLayerController.h"
#import "TJ_ImgView.h"
#import "UIImage+TJ.h"

@interface TJMoreLayerController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray            *ImgViewArrM;

@property (nonatomic, strong) TJ_ImgView                *testImgView;

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
    panGesture.delegate = self;
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [self.view addGestureRecognizer:panGesture];
    
    self.ImgViewArrM = [NSMutableArray array];
    self.testImgView = [[TJ_ImgView alloc] initWithFrame:CGRectMake(0, 64, 325, 183)];
    [self.view addSubview:_testImgView];
    
    self.testImgView.layer.borderWidth = 1.0;
    self.testImgView.layer.borderColor = [UIColor blueColor].CGColor;
    
    self.testImgView.backgroundColor = [UIColor redColor];
    
    
    
    NSMutableArray *imgArrM = [NSMutableArray array];
    
    for (int i = 0; i < 13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
        [imgArrM addObject:image];
    }
    self.testImgView.animationImages = imgArrM; //获取Gif图片列表
    self.testImgView.animationDuration = 2.5;     //执行一次完整动画所需的时长
    self.testImgView.animationRepeatCount = 100;  //动画重复次数
    [self.testImgView startAnimating];
    
    
    
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
    TJ_ImgView *view = self.testImgView;
    if (view.tj_scale > 3.0 && pinchGesture.scale > 1.0) return;
    if (view.tj_scale < 0.5 && pinchGesture.scale < 1.0) return;
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGesture.scale, pinchGesture.scale);
        pinchGesture.scale = 1;
    }
    view.layer.borderWidth = 1.0 / view.tj_scale;
}

/** 旋转 */
- (void)rotateAction:(UIRotationGestureRecognizer *)rotateGesture
{
    TJ_ImgView *view = self.testImgView;
    if (rotateGesture.state == UIGestureRecognizerStateBegan || rotateGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotateGesture.rotation);
        NSLog(@"%f", rotateGesture.rotation);
        [rotateGesture setRotation:0];
    }
}

/** 平移 */
- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    TJ_ImgView *view = self.testImgView;
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
