//
//  TestBaseVC.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenCVDemo.hpp"
#import "GrammarTest.hpp"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@interface TestBaseVC : UIViewController


@property (nonatomic, weak) UIImageView                     *srcImageView;


@property (nonatomic, strong) UISlider                        *slider1;
@property (nonatomic, strong) UISlider                      *slider2;
@property (nonatomic, strong) UISlider                      *slider3;


@property (nonatomic, copy) NSString                        *imageName;
@property (nonatomic, copy) NSString                        *imgName2;


- (void)sliderValueChange:(UISlider *)slider;


/** 设置editImageView的frame */
- (void)resetEditImageViewFrame;


@end
