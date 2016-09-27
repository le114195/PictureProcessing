//
//  TJ_DrawTool_C.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/27.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef TJ_DrawTool_C_h
#define TJ_DrawTool_C_h

#include <stdio.h>




/** point结构体 */
typedef struct {
    double  x;
    double  y;
}TJ_Point;


/** 指针函数 */
typedef void(*pfv)(TJ_Point point);


TJ_Point newPoint(TJ_Point lastLocation, TJ_Point location, double distance);


/** 等距离移动 */
void constDistanceMoved(TJ_Point location, double radius, double dis, int isStartMove, pfv pFunc);


#endif /* TJ_DrawTool_C_h */
