//
//  GPUImageTestVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "GPUImageTestVC.h"
#import "GPUImageTest.h"

@interface GPUImageTestVC ()

@property (nonatomic, copy) NSString                        *imgName;
@property (nonatomic, strong) UIImage                       *originImage;


@property (nonatomic, strong) GPUImagePicture               *gpuImage;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *sepiaFilter;


@end

@implementation GPUImageTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgName = @"sj_20160705_30.JPG";
    
    
    [self gpuImageTest];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)sliderValueChange:(UISlider *)slider
{

    [(GPUImageVignetteFilter *)self.sepiaFilter setVignetteCenter:CGPointMake(slider.value, slider.value)];
    
    self.srcImageView.image = [self.sepiaFilter imageByFilteringImage:self.originImage];
    
}




- (void)gpuImageTest {
    
    self.originImage = [UIImage imageNamed:self.imgName];
    
    self.sepiaFilter = [[GPUImageVignetteFilter alloc] init];
    
    self.srcImageView.image = [self.sepiaFilter imageByFilteringImage:self.originImage];
    
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    self.slider.value = 0.5;
    
}



@end
