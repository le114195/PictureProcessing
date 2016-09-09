//
//  MathFunc.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/6.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "MathFunc.h"

@implementation MathFunc


+ (CGPoint)newPointWithLastLocation:(CGPoint)lastLocation local:(CGPoint)location distance:(float)distance
{
    float x0, y0, a, b, c, c0;
    float slope; //斜率
    if (location.x == lastLocation.x) {
        x0 = location.x;
        if (location.y > lastLocation.y) {
            y0 = lastLocation.y + distance;
        }else {
            y0 = location.y + distance;
        }
    }else {
        slope = (double)(location.y - lastLocation.y) / (location.x - lastLocation.x);
        c0 = location.y - slope * location.x;
        
        a = slope * slope + 1;
        b = 2 * slope * (c0 - lastLocation.y) - 2 * lastLocation.x;
        c = lastLocation.x * lastLocation.x + (c0 - lastLocation.y) * (c0 - lastLocation.y) - distance * distance;

        if (lastLocation.x < location.x) {
            x0 = (-b + sqrt(b * b - 4 * a * c)) / (2 * a);
        }else {
            x0 = (-b - sqrt(b * b - 4 * a * c)) / (2 * a);
        }
        y0 = slope * x0 + c0;
    }
    return CGPointMake(x0, y0);
}




@end
