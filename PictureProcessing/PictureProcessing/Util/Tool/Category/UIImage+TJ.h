//
//  UIImage+TJ.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (TJ)


- (void)saveImageWithImgName:(NSString *)imgName imageType:(int)imageType;

-(UIImage *)fixOrientation;

/** 画图 */
- (void)drawAtCenter:(CGPoint)center Alpha:(CGFloat) alpha withTranslation:(CGPoint)translation radian:(CGFloat)radian scale:(CGFloat)scale;


/** 左右反转图片 */
- (UIImage *)tj_reversal;

/** 上下反转图片 */
- (UIImage *)tj_invert;

/** 上下反转图片 */
- (UIImage *)tj_invert;

@end
