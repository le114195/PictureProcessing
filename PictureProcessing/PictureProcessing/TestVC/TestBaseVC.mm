//
//  TestBaseVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TestBaseVC.h"

@interface TestBaseVC ()

@end

@implementation TestBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self subViewConfigure];
    
    self.imageName = PictureHeader(@"sj_20160705_1.JPG");
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)subViewConfigure
{
    CGFloat imgWidth = (ScreenWidth / ScreenHeight) * (ScreenHeight - 64);
    
    UIImageView *srcImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - imgWidth) * 0.5, 64, imgWidth, ScreenHeight - 64)];
    self.srcImageView = srcImageView;
    srcImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:srcImageView];
    
}



- (void)sliderValueChange:(UISlider *)slider
{

}


- (UISlider *)slider1
{
    if (!_slider1) {
        
        _slider1 = [[UISlider alloc] init];
        _slider1.tag = 100;
        _slider1.frame = CGRectMake(20, ScreenHeight - 60, ScreenWidth - 40, 30);
        [self.view addSubview:_slider1];
        [_slider1 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider1;
}


- (UISlider *)slider2
{
    if (!_slider2) {
        
        _slider2 = [[UISlider alloc] init];
        _slider2.tag = 101;
        _slider2.frame = CGRectMake(20, ScreenHeight - 100, ScreenWidth - 40, 30);
        [self.view addSubview:_slider2];
        [_slider2 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider2;
}


- (UISlider *)slider3
{
    if (!_slider3) {
        _slider3 = [[UISlider alloc] init];
        _slider3.tag = 102;
        _slider3.frame = CGRectMake(20, ScreenHeight - 140, ScreenWidth - 40, 30);
        [self.view addSubview:_slider3];
        [_slider3 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider3;
}


@end
