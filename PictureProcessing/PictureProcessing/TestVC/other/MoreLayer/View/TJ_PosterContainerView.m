//
//  TJ_PosterContaintView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/24.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_PosterContainerView.h"
#import "TJ_PosterView.h"


@interface TJ_PosterContainerView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat           scale;
@property (nonatomic, assign) CGFloat           angle;
@property (nonatomic, assign) CGPoint           offset;


@end


@implementation TJ_PosterContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapActionNotification:) name:@"TJ_PosterTapGestureNotification" object:nil];
        [self gestureConfigure];
    }
    return self;
}

#pragma mark - 手势

- (void)gestureConfigure
{
    //缩放
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
    
//    //旋转
//    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
//    rotationGesture.delegate = self;
//    [self addGestureRecognizer:rotationGesture];
    
    //平移
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [self addGestureRecognizer:panGesture];
}


/** 缩放 */
- (void)pinchAction:(UIPinchGestureRecognizer *)pinchGesture
{
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.scale = 1;
    }else if (pinchGesture.state == UIGestureRecognizerStateChanged) {
        self.currentPoster.transform = CGAffineTransformScale(self.currentPoster.transform, pinchGesture.scale, pinchGesture.scale);
        self.currentPoster.tj_scale *= pinchGesture.scale;
        self.scale *= pinchGesture.scale;
        pinchGesture.scale = 1;
    }else if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        if (self.scaleBlock) {
            self.scaleBlock(self.scale);
        }
    }
    
    self.currentPoster.layer.borderWidth = 1.0 / self.currentPoster.tj_scale;
}

/** 旋转 */
- (void)rotateAction:(UIRotationGestureRecognizer *)rotateGesture
{
    if (rotateGesture.state == UIGestureRecognizerStateBegan) {
        
    }else if (rotateGesture.state == UIGestureRecognizerStateChanged) {
        self.currentPoster.transform = CGAffineTransformRotate(self.currentPoster.transform, rotateGesture.rotation);
        self.currentPoster.tj_angle += rotateGesture.rotation;
        self.angle += rotateGesture.rotation;
        [rotateGesture setRotation:0];
    }else if (rotateGesture.state == UIGestureRecognizerStateEnded) {
        if (self.rotateBlock) {
            self.rotateBlock(self.angle);
        }
    }
    
}

/** 平移 */
- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.offset = CGPointMake(0, 0);
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self.currentPoster.superview];
        [self.currentPoster setCenter:(CGPoint){self.currentPoster.center.x + translation.x, self.currentPoster.center.y + translation.y}];
        self.currentPoster.tj_offset = CGPointMake(self.currentPoster.tj_offset.x + translation.x, self.currentPoster.tj_offset.y + translation.y);
        
        self.offset = CGPointMake(translation.x + self.offset.x, translation.y + self.offset.y);
        [panGesture setTranslation:CGPointZero inView:self.currentPoster.superview];
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.translationBlock) {
            self.translationBlock(self.offset);
        }
    }
    
}


//同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - 通知事件

- (void)tapActionNotification:(NSNotification *)notiP
{
    self.currentPoster = (TJ_PosterView*)[notiP object];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TJ_PosterTapGestureNotification" object:nil];
}



@end
