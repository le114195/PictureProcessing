//
//  MathFunc.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/6.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MathFunc : NSObject


/**
 *  利用两点式得到一个一次函数，然后求出距离第一个点距离为distance 的点
 *
 *  @param lastLocation 第一个点
 *  @param location     第二个点
 *  @param distance     待求的点到第一个点的距离
 *
 *  @return 返回待求的点
 */
+ (CGPoint)newPointWithLastLocation:(CGPoint)lastLocation local:(CGPoint)location distance:(float)distance;


@end
