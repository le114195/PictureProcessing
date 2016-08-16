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
@property (nonatomic, strong) GPUImageTest                  *tjGPU;


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
    //
    // Dispose of any resources that can be recreated.
}



- (void)sliderValueChange:(UISlider *)slider
{

    self.tjGPU.whiteBalanceFilter.temperature = slider.value;
    
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self.tjGPU.whiteBalanceFilter imageByFilteringImage:self.originImage];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = image;
        });
    });
}



- (void)gpuImageTest {
    
    self.originImage = [UIImage imageNamed:self.imgName];

    self.srcImageView.image = [self.tjGPU.sketchFilter imageByFilteringImage:self.originImage];
    
    
    
    self.slider.maximumValue = 1;
    self.slider.minimumValue = 0;
    
    self.slider.value = 0;
}


- (GPUImageTest *)tjGPU
{
    if (!_tjGPU) {
        _tjGPU = [GPUImageTest shareInstance];
    }
    return _tjGPU;
}


@end
