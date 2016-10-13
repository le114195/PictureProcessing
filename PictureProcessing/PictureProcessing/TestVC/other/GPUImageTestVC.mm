//
//  GPUImageTestVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "GPUImageTestVC.h"
#import "GPUImageTest.h"
#import "TJCustomFilter.h"

@interface GPUImageTestVC ()

@property (nonatomic, copy) NSString                        *imgName;
@property (nonatomic, strong) UIImage                       *originImage;


@property (nonatomic, strong) GPUImagePicture               *gpuImage;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *specialFilter;
@property (nonatomic, strong) GPUImageTest                  *tjGPU;


@end

@implementation GPUImageTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgName = @"image003.jpg";
    
    
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
//    self.tjGPU.zoomBlurFilter.blurCenter = CGPointMake(slider.value, slider.value);

    [self.specialFilter setValue:@(slider.value) forKey:@"blurRadiusInPixels"];
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self.specialFilter imageByFilteringImage:self.originImage];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = image;
        });
    });
}



- (void)gpuImageTest {
    
    self.originImage = [UIImage imageNamed:self.imgName];
    [self resetEditImageViewFrame];
    
//    self.sepiaFilter = self.tjGPU.toneCurveFilter;
//    [self.sepiaFilter setValue:@10 forKey:@"blurRadiusInPixels"];
//    
//    
//    UIImage *image = [self.sepiaFilter imageByFilteringImage:self.originImage];
//    
//    
//    GPUImagePicture *pic1 = [[GPUImagePicture alloc] initWithImage:image];
//    GPUImagePicture *pic2 = [[GPUImagePicture alloc] initWithImage:self.originImage];
//    self.sepiaFilter = self.tjGPU.colorBurnBlendFilter;
//    
//    [pic1 addTarget:self.sepiaFilter];
//    [pic2 addTarget:self.sepiaFilter];
//    
//    [self.sepiaFilter useNextFrameForImageCapture];
//    
//    
//    [pic1 processImage];
//    [pic2 processImage];
//    
//    self.srcImageView.image = [self.sepiaFilter imageFromCurrentFramebuffer];
    
    
    
    
    
    self.specialFilter = [[GPUImagePinchDistortionFilter alloc] init];
    
    
    [self.specialFilter setValue:[NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)] forKey:@"center"];
    [self.specialFilter setValue:@0.5 forKey:@"radius"];
    

    __block UIImage *renderImg = self.originImage;
    
    for (int i = 0; i < 5; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            renderImg = [self.specialFilter imageByFilteringImage:renderImg];
            self.srcImageView.image = renderImg;
        });
    }
    
    //self.srcImageView.image = [self.specialFilter imageByFilteringImage:self.originImage];

}


//GPUImageSwirlFilter:旋转扭曲
//GPUImageBulgeDistortionFilter:膨胀扭曲
//GPUImagePinchDistortionFilter:收缩扭曲
//GPUImageStretchDistortionFilter
//GPUImageSphereRefractionFilter
//GPUImageGlassSphereFilter

- (GPUImageTest *)tjGPU
{
    if (!_tjGPU) {
        _tjGPU = [GPUImageTest shareInstance];
    }
    return _tjGPU;
}


@end
