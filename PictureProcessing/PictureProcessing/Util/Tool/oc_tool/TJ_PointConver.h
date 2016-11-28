//
//  TJ_PointConver.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/24.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJ_PointConver : NSObject


+ (CGPoint)tj_scale:(CGFloat)scale point:(CGPoint)point;


+ (CGPoint)tj_angle:(CGFloat)angle point:(CGPoint)point;


+ (CGPoint)tj_conver:(CGPoint)point scale:(CGFloat)scale angle:(CGFloat)angle;



+ (CGFloat)tj_anglePoint:(CGPoint)point;

@end
