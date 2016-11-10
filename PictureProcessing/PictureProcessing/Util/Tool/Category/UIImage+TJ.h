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

- (UIImage *)rotate;


@end
