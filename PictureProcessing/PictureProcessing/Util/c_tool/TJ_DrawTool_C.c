//
//  TJ_DrawTool_C.c
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/27.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "TJ_DrawTool_C.h"
#include <math.h>
#include <stdlib.h>


void constDistanceMoved(TJ_Point location, double radius, double dis, int isStartMove, pfv pFunc)
{
    static float           previousAngle;
    static float*           vertexBuffer = NULL;
    static TJ_Point         previousPoint;
    float                  angle,
                            distance,
                            newDis = 0.0;
    
    if (vertexBuffer == NULL) {
        vertexBuffer = malloc(64 * 2 * sizeof(float));
    }
    
    if (isStartMove) {
        previousPoint = location;
        angle = atan((location.y - previousPoint.y) / (location.x - previousPoint.x));
        previousAngle = angle;
    }
    angle = atan((location.y - previousPoint.y) / (location.x - previousPoint.x));
    distance = hypot(fabs(location.y - previousPoint.y), fabs(location.x - previousPoint.x));
    
    if (distance < 2 * radius) {
        return;
    }
    if (fabs(previousAngle - angle) < M_PI_4 && distance < dis) {
        return;
    }else if (distance > dis) {
        int count = distance / dis;
        if (count < 64) {
            newDis = dis;
        }else {
            count = 64;
            newDis = distance / 64;
        }
        for (int i = 0; i < count; i++) {
            previousPoint = newPoint(previousPoint, location, newDis);
            vertexBuffer[2*i + 0] = previousPoint.x;
            vertexBuffer[2*i + 1] = previousPoint.y;
        }
        if (pFunc != NULL) {
            pFunc(vertexBuffer, count);
        }
    }
    previousAngle = angle;
}


TJ_Point newPoint(TJ_Point lastLocation, TJ_Point location, double distance)
{
    TJ_Point newPoint;
    
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
    newPoint.x = x0;
    newPoint.y = y0;
    return newPoint;
}



