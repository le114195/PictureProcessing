//
//  CoreImageVCTest.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "CoreImageVCTest.h"
#import "CoreImgeTest.h"

@interface CoreImageVCTest ()


@property (nonatomic, copy) NSString                        *imgName;

@property (nonatomic, strong) CoreImgeTest                  *coreImage;


@end


@implementation CoreImageVCTest


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgName = @"sj_20160705_1.JPG";
    
    [self coreImageTest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)sliderValueChange:(UISlider *)slider
{
    [self.coreImage.filter setValue:@(slider.value) forKey:@"inputAngle"];
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self.coreImage rendering];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = image;
        });
    });
}




#pragma mark - coreImage

- (void)coreImageTest {
    
    [self.coreImage filterWithImage:[UIImage imageNamed:self.imgName] filterName:@"ColorInvert"];
    
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self.coreImage rendering];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = image;
        });
    });
    
    self.slider.maximumValue = 1;
    self.slider.minimumValue = 0;
    self.slider.value = 0;
}






- (CoreImgeTest *)coreImage
{
    if (!_coreImage) {
        _coreImage = [CoreImgeTest shareInstance];
    }
    return _coreImage;
}


@end
