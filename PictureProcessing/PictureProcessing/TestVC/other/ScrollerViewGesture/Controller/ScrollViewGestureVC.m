//
//  ScrollViewGestureVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "ScrollViewGestureVC.h"

@interface ScrollViewGestureVC ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView            *scrollerView;
@property (nonatomic, weak) UIImageView             *imgView;

@end

@implementation ScrollViewGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollerView = scrollView;
    
    [self.view addSubview:scrollView];
    
    
    for (UIGestureRecognizer *mgestureRecognizer in scrollView.gestureRecognizers) {
        if ([mgestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        {
            UIPanGestureRecognizer *mpanGR = (UIPanGestureRecognizer *) mgestureRecognizer;
            
            [mpanGR setValue:@2 forKey:@"maximumNumberOfTouches"];
            [mpanGR setValue:@2 forKey:@"minimumNumberOfTouches"];
        }
    }
    
    
    UIImage *image=[UIImage imageNamed:@"sj_20160705_10.JPG"];
    UIImageView *imgView =[[UIImageView alloc]initWithImage:image];
    imgView.userInteractionEnabled = YES;
    imgView.frame = self.view.bounds;
    self.imgView = imgView;
    //调用initWithImage:方法，它创建出来的imageview的宽高和图片的宽高一样
    [self.scrollerView addSubview:imgView];
    
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    self.scrollerView.contentSize = self.view.bounds.size;
    
    
    //设置实现缩放
    //设置代理scrollview的代理对象
    self.scrollerView.delegate=self;
    //设置最大伸缩比例
    self.scrollerView.maximumZoomScale=5.0;
    //设置最小伸缩比例
    self.scrollerView.minimumZoomScale=1.0;
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [imgView addGestureRecognizer:panGesture];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    
    
    
    //    UIView *gestureView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:gestureView];
    //
    //    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    //    [gestureView addGestureRecognizer:panGesture];
    //    panGesture.minimumNumberOfTouches = 1;
    //    panGesture.maximumNumberOfTouches = 1;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (self.imgView.frame.size.width <= scrollView.bounds.size.width || self.imgView.frame.size.height <= scrollView.bounds.size.height) {
        [self.imgView setCenter:CGPointMake(scrollView.bounds.size.width * 0.5, scrollView.bounds.size.height * 0.5)];
    }
}



- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    NSLog(@"dfedfe");
}

@end
