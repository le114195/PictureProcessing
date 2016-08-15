//
//  CoreImgeTest.h
//  openCV
//
//  Created by 勒俊 on 16/8/10.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface CoreImgeTest : NSObject

+ (instancetype)shareInstance;


@property (nonatomic, strong)  CIFilter             *filter;


- (void)filterWithImage:(UIImage *)image filterName:(NSString *)filterName;



/** 渲染图片 */
- (UIImage *)rendering;

@end

/** CICategoryBlur:模糊类 */

//CIBoxBlur

//CIDiscBlur




//CISepiaTone:色调调整


//CIPhotoEffectMono:单通道













