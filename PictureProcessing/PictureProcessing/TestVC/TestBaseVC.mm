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
    
    UISlider *slider = [[UISlider alloc] init];
    self.slider = slider;
    slider.frame = CGRectMake(20, ScreenHeight - 60, ScreenWidth - 40, 30);
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)sliderValueChange:(UISlider *)slider
{

}




@end
