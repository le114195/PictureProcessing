//
//  TJ_DrawTool.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_DrawTool.h"
#import "TJ_DrawTool_C.h"





void pFunc(float* verBuffer, int count);


static DrawCompletionBlock  DrawCompletion;

@implementation TJ_DrawTool


+ (void)constDisDraw:(CGPoint)location dis:(double)dis isStartMove:(BOOL)isStartMove completion:(DrawCompletionBlock)completion
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
    constDistanceMoved(tj_Point, dis, isStartM, &pFunc);
}

void pFunc(float* verBuffer, int count)
{
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [arrM addObject:[NSValue valueWithCGPoint:CGPointMake(verBuffer[2*i + 0], verBuffer[2*i + 1])]];
    }
    if (DrawCompletion) {
        DrawCompletion(arrM);
    }
}





@end
