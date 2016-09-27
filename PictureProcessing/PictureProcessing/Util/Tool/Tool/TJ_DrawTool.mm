//
//  TJ_DrawTool.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_DrawTool.h"
#import "TJ_DrawTool_C.h"


void pFunc(TJ_Point point);


@implementation TJ_DrawTool

+ (CGPoint)newPointLastPoint:(CGPoint)lastLocation currentPoint:(CGPoint)location distance:(double)distance
{
    
    double x0, y0, a, b, c, c0;
    double slope = 0; //斜率
    if (location.x == lastLocation.x) {
        x0 = location.x;
        if (location.y > lastLocation.y) {//向下
            y0 = lastLocation.y + distance;
        }else {//向上
            y0 = lastLocation.y - distance;
        }
    }else {
        slope = 1.0 * (location.y - lastLocation.y) / (location.x - lastLocation.x);
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


//+ (void)constDisDraw:(CGPoint)location radius:(double)radius dis:(double)dis isStartMove:(BOOL)isStartMove
//{
//    TJ_Point tj_Point;
//    tj_Point.x = location.x;
//    tj_Point.y = location.y;
//    
//    int isStartM;
//    if (isStartMove) {
//        isStartM = 1;
//    }else {
//        isStartM = 0;
//    }
//    constDistanceMoved(tj_Point, radius, dis, isStartM, &pFunc);
//}



void pFunc(TJ_Point point)
{
    NSLog(@"dfedfe");
}





@end
