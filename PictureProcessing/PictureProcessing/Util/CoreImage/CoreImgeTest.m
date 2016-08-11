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
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    // 创建滤镜
    self.filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
}


- (UIImage *)rendering
{
    // 渲染并输出CIImage
    CIImage *outputImage = [self.filter outputImage];
    
    // 创建CGImage句柄
    CGImageRef cgImage = [self.context createCGImage:outputImage
                                            fromRect:[outputImage extent]];
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
