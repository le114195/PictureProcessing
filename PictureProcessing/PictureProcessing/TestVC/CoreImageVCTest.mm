//
//  CoreImageVCTest.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "CoreImageVCTest.h"
#import "CoreImgeTest.h"
#import "OpenCVDemo.hpp"

@interface CoreImageVCTest ()


@property (nonatomic, weak) UICollectionView                *collectionView;


@property (nonatomic, copy) NSString                        *inputImg;
@property (nonatomic, copy) NSString                        *imgName;

@property (nonatomic, strong) CoreImgeTest                  *coreImage;

@property (nonatomic, strong) NSString                      *filterName;

@property (nonatomic, strong) NSArray                       *sliderValue;


@property (nonatomic, copy) NSString                        *paraName1;
@property (nonatomic, copy) NSString                        *paraName2;
@property (nonatomic, copy) NSString                        *paraName3;

@end


@implementation CoreImageVCTest


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imgName = @"sj_20160705_1.JPG";
    self.inputImg = @"sj_20160705_2.JPG";
    [self coreImageTest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)sliderValueChange:(UISlider *)slider
{
    switch (slider.tag) {
        case 100:{
            [self.coreImage.filter setValue:@(slider.value) forKey:self.paraName1];
            break;
        }
        case 101:{
            [self.coreImage.filter setValue:@(slider.value) forKey:self.paraName2];
            break;
        }
        case 102:{
            [self.coreImage.filter setValue:@(slider.value) forKey:self.paraName3];
            break;
        }
        default:
            break;
    }
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [self.coreImage rendering];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = image;
        });
    });
}




- (void)setParameters:(NSDictionary *)parameters
{
    _parameters = parameters;
    
    self.filterName = [parameters valueForKey:@"filterName"];
    
    self.sliderValue = [parameters valueForKey:@"sliderValue"];
    
}





#pragma mark - coreImage

- (void)coreImageTest {
    
    TJScale *scale = new TJScale();
    UIImage *image = MatToUIImage(scale->resize_demo([self.imageName UTF8String], 1));
    
    
    [self.coreImage filterWithImage:image filterName:self.filterName];
    
//    CIVector *vec = [CIVector vectorWithX:10 Y:10];
//    
//    [self.coreImage.filter setValue:vec forKey:@"inputCenter"];
//
    
    if (self.sliderValue && self.sliderValue.count > 0) {
        for (int i= 0; i < self.sliderValue.count; i++) {
            
            NSDictionary *dict = self.sliderValue[i];
            
            NSNumber *defaultValue = [dict valueForKey:@"defauleValue"];
            NSNumber *mini = [dict valueForKey:@"mini"];
            NSNumber *max = [dict valueForKey:@"max"];
            
            NSString *name = [dict valueForKey:@"name"];
            
            UISlider *slider = nil;
            
            switch (i) {
                case 0:{
                    slider = self.slider1;
                    self.paraName1 = name;
                    break;
                }
                case 1:{
                    slider = self.slider2;
                    self.paraName2 = name;
                    break;
                }
                case 2:{
                    slider = self.slider3;
                    self.paraName3 = name;
                    break;
                }
                default:
                    break;
            }
            slider.maximumValue = [max floatValue];
            slider.minimumValue = [mini floatValue];
            slider.value = [defaultValue floatValue];

            [self.coreImage.filter setValue:defaultValue forKey:name];
        }
    }
    __block UIImage *imageBlock;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        imageBlock = [self.coreImage rendering];
        tj_dispatch_main_sync_safe(^{
            self.srcImageView.image = imageBlock;
        });
    });
}

- (CoreImgeTest *)coreImage
{
    if (!_coreImage) {
        _coreImage = [[CoreImgeTest alloc] init];
    }
    return _coreImage;
}


@end
