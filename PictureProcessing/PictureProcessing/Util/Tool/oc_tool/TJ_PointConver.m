//
//  TJ_PointConver.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/24.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_PointConver.h"

@implementation TJ_PointConver

+ (CGPoint)tj_scale:(CGFloat)scale point:(CGPoint)point
{
    return CGPointMake(point.x * scale, point.y * scale);
}


+ (CGPoint)tj_angle:(CGFloat)angle point:(CGPoint)point
{
    CGFloat totalAngle = 0;
    if (point.x == 0) {
        totalAngle = point.y / fabs(point.y) * M_PI_2 + angle;
    }else {
        totalAngle = atan(point.y / point.x) + angle;
    }
    CGFloat r = sqrt(point.x * point.x + point.y * point.y);
    return CGPointMake(r * cos(totalAngle), r * sin(totalAngle));
}

+ (CGPoint)tj_conver:(CGPoint)point scale:(CGFloat)scale angle:(CGFloat)angle
{
    CGPoint newPoint;
    newPoint = [self tj_scale:scale point:point];
    newPoint = [self tj_angle:angle point:newPoint];
    return newPoint;
}

@end
