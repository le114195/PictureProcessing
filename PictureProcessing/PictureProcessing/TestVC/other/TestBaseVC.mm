//
//  TestBaseVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TestBaseVC.h"


#define BottomViewHeight       0
#define EditNaviHeight         64

@interface TestBaseVC ()

@end

@implementation TestBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self subViewConfigure];
    
    self.imageName = PictureHeader(@"01.png");
    
//    self.imageName = PictureHeader(@"sj_20160705_1.JPG");
    self.imgName2 = PictureHeader(@"02.png");

    
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
    CGFloat imgWidth = (Screen_Width / Screen_Height) * (Screen_Height - 64);
    
    UIImageView *srcImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width - imgWidth) * 0.5, 64, imgWidth, Screen_Height - 64)];
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
        _slider1.frame = CGRectMake(20, Screen_Height - 60, Screen_Width - 40, 30);
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
        _slider2.frame = CGRectMake(20, Screen_Height - 100, Screen_Width - 40, 30);
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
        _slider3.frame = CGRectMake(20, Screen_Height - 140, Screen_Width - 40, 30);
        [self.view addSubview:_slider3];
        [_slider3 addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider3;
}



/** 设置editImageView的frame */
- (void)resetEditImageViewFrame {
    if (self.srcImageView.image) {
        CGFloat screen_height = Screen_Height - (EditNaviHeight + BottomViewHeight);
        CGFloat imageWidth = self.srcImageView.image.size.width;
        CGFloat imageHeight = self.srcImageView.image.size.height;
        CGFloat imageRate = imageWidth / imageHeight;
        
        if (imageRate >= Screen_Width / screen_height) {
            imageHeight = imageHeight * Screen_Width / imageWidth;
            imageWidth = Screen_Width;
        }else {
            imageWidth = imageWidth * screen_height / imageHeight;
            imageHeight = screen_height;
        }
        self.srcImageView.frame = CGRectMake((Screen_Width - imageWidth) / 2, EditNaviHeight + (Screen_Height - imageHeight - (EditNaviHeight + BottomViewHeight)) / 2, imageWidth, imageHeight);
    }else {
        self.srcImageView.frame = CGRectMake(0, (Screen_Height - Screen_Width) / 2, Screen_Width, Screen_Width);
    }
}


@end
