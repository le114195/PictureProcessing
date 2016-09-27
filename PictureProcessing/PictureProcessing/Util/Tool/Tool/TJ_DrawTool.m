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


static DrawCompletionBlock  DrawCompletion;

@implementation TJ_DrawTool


+ (void)constDisDraw:(CGPoint)location radius:(double)radius dis:(double)dis isStartMove:(BOOL)isStartMove completion:(DrawCompletionBlock)completion
{
    DrawCompletion = completion;
    
    TJ_Point tj_Point;
    tj_Point.x = location.x;
    tj_Point.y = location.y;
    
    int isStartM;
    if (isStartMove) {
        isStartM = 1;
    }else {
        isStartM = 0;
    }
    constDistanceMoved(tj_Point, radius, dis, isStartM, &pFunc);
}



void pFunc(TJ_Point point)
{
    CGPoint location = CGPointMake(point.x, point.y);
    if (DrawCompletion) {
        DrawCompletion(location);
    }
}





@end
