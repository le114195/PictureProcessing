//
//  TJ_PictureBaseVC.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TJ_PictureBaseVC : TJ_BaseController

@property (nonatomic, strong) UIImageView           *srcImgView;

@property (nonatomic, strong) UIImage               *srcImg;


+ (instancetype)picture:(UIImage *)image;

- (instancetype)initWithImg:(UIImage *)image;

/** 设置editImageView的frame */
- (CGRect)resetImageViewFrameWithImage:(UIImage *)image top:(CGFloat)top bottom:(CGFloat)bottom;



@end
