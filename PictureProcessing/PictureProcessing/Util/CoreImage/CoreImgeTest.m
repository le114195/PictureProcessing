//
//  CoreImgeTest.m
//  openCV
//
//  Created by 勒俊 on 16/8/10.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "CoreImgeTest.h"
#import <CoreImage/CoreImage.h>


@interface CoreImgeTest ()

@property (nonatomic, strong) CIContext         *context;

@property (nonatomic, strong) CIImage           *inputImage;

@end




@implementation CoreImgeTest


- (CIContext *)context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}


- (void)filterWithImage:(UIImage *)image filterName:(NSString *)filterName
{
    // 将UIImage转换成CIImage
    self.inputImage = [[CIImage alloc] initWithImage:image];
    
    // 创建滤镜
    self.filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, self.inputImage, nil];
}

/** 渲染图片 */
- (UIImage *)rendering
{
    // 创建CGImage句柄
    CGImageRef cgImage = [self.context createCGImage:self.filter.outputImage
                                        fromRect:[self.inputImage extent]];
    // 获取图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    return showImage;
}



#pragma mark - 单利实现

+ (instancetype)shareInstance
{
    static CoreImgeTest *core;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [[super allocWithZone:NULL] init];
    });
    return core;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [CoreImgeTest shareInstance];
}

@end
