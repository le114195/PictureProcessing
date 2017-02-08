//
//  GravityTxtView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "GravityTxtView.h"


@interface GravityTxtView ()<UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator         *animator;

@property (nonatomic, strong) NSMutableArray            *arrM;
@property (nonatomic, weak) UIView                      *containerView;


@end


@implementation GravityTxtView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        CGFloat txtSize = 37.0;
        
        self.backgroundColor = [UIColor greenColor];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, Screen_Width, 200)];
        [self addSubview:containerView];
        containerView.backgroundColor = [UIColor whiteColor];
        self.containerView = containerView;
        containerView.layer.masksToBounds = YES;
        
        self.arrM = [NSMutableArray array];
        
        NSArray *array = @[@"哈", @"哈", @"哈", @"哈"];
        
        int i = 0;
        for (NSString *str in array) {
            
            UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + i * (txtSize + 5), -200, txtSize, txtSize)];
            [containerView addSubview:testLabel];
            
            testLabel.font = [UIFont systemFontOfSize:txtSize];
            testLabel.backgroundColor = [UIColor redColor];
            testLabel.text = str;
            
            [self.arrM addObject:testLabel];
            i++;
        }

    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.animator removeAllBehaviors];
    
    for (int i = 0; i < self.arrM.count; i++) {
        UIView *view = self.arrM[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gravity:view];
            [self collision:view];
        });
    }
}



- (void)gravity:(UIView *)view
{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[view]];
    
    /*
     CGVector 表示方向的结构体
     CGFloat dx : X轴的方向
     CGFloat dy : Y轴的方向
     
     gravityDirection 默认是（0.0,1.0）向下每秒下降1000个像素点 受其他因素的影响（加速度 弧度）
     */
    gravity.gravityDirection = CGVectorMake(0.0, 1.0);
    
    //会影响到重力的方向
    // gravity.angle = 30*M_PI/180;
    //magnitude 会影响到下降的速度
    //gravity.magnitude = 100;
    //把重力效果添加到动力效果的操纵者上
    [self.animator addBehavior:gravity];
    
}


//MARK: -----检测碰撞的行为
- (void)collision:(UIView *)view {
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[view]];
    //设置 检测碰撞的模式
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    //以参照视图为边境范围
    //  collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 300, 300, 300) cornerRadius:150];
    //    重力行为随着画的圆的轨迹 如果重力作用对象放在在圆里面将只会在里面 反之将会随着圆弧掉落
    //    [collisionBehavior addBoundaryWithIdentifier:@"round" forPath:path];
    
    [collisionBehavior addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(0, 100) toPoint:CGPointMake(400,100)];
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
}


- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.containerView];
        _animator.delegate = self;
    }
    return _animator;
}


#pragma mark ------碰撞行为的代理方法
//检测元素与元素之间碰撞的
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
    
    
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2{
    
}
//检测元素与边界之间碰撞的
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    
    
    
    
    NSLog(@"开始接触到边境调用此方法");
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier{
    
    
    NSLog(@"结束接触到边境调用此方法");
}

//MARK: -------动力效果操纵者的代理方法
//动画开始调用
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator{
    
}





@end
