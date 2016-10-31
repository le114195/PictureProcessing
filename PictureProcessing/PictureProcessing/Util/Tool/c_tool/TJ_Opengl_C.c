//
//  TJ_Opengl_C.c
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "TJ_Opengl_C.h"
#include <math.h>



void configure_attrArr(GLfloat *attrArr, GLint rectW, GLint rectH)
{
    GLfloat rateX = 2.0/(rectW - 1);
    GLfloat rateY = 2.0/(rectH - 1);
    for (int i = 0; i < rectW * rectH; i++) {
        attrArr[i * 5] = -1 + rateX * (i%rectW);
        attrArr[i * 5 + 1] = 1 - (i/rectW) * rateY;
        attrArr[i * 5 + 2] = 0;
        attrArr[i * 5 + 3] = (i%rectW) * rateX * 0.5;
        attrArr[i * 5 + 4] = (i/rectW) * rateY * 0.5;
    }
}

void configure_indices(GLint *indices, GLint rectW, GLint rectH)
{
    for (int i = 0; i < (rectW - 1) * (rectH - 1); i++) {
        indices[i * 6] = i / (rectW - 1) * rectW + i%(rectW - 1);
        indices[i * 6 + 1] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1);
        indices[i * 6 + 2] = i / (rectW - 1) * rectW + rectW +  + i%(rectW - 1) + 1;
        
        indices[i * 6 + 3] = i / (rectW - 1) * rectW + i%(rectW - 1);
        indices[i * 6 + 4] = i / (rectW - 1) * rectW + i%(rectW - 1) + 1;
        indices[i * 6 + 5] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1) + 1;
    }
}


void tj_curve_eye(GLfloat *attrArr, GLuint rectLength, double ImgWidth, double ImgHeight, TJ_GLPoint eye_top, TJ_GLPoint eye_bottom, TJ_GLPoint eye_left_corner, TJ_GLPoint eye_right_corner)
{
    double aspectRatio = 1.0 * ImgHeight / ImgWidth;
    
    //坐标变换
    TJ_GLPoint _eye_top, _eye_bottom, _eye_left_corner, _eye_right_corner;
    
    _eye_top.x = eye_top.x / ImgWidth * 2 - 1;
    _eye_top.y = aspectRatio - eye_top.y / ImgWidth * 2;
    
    _eye_bottom.x = eye_bottom.x / ImgWidth * 2 - 1;
    _eye_bottom.y = aspectRatio - eye_bottom.y / ImgWidth * 2;
    
    _eye_left_corner.x = eye_left_corner.x / ImgWidth * 2 - 1;
    _eye_left_corner.y = aspectRatio - eye_left_corner.y / ImgWidth * 2;
    
    _eye_right_corner.x = eye_right_corner.x / ImgWidth * 2 - 1;
    _eye_right_corner.y = aspectRatio - eye_right_corner.y / ImgWidth * 2;
    
    //_eye_top到_eye_bottom的距离
    double dist = sqrt((_eye_top.x - _eye_bottom.x)*(_eye_top.x - _eye_bottom.x) + (_eye_top.y - _eye_bottom.y)*(_eye_top.y - _eye_bottom.y));
    
    //直线方程：Ax + By + C = 0;经过点_eye_left_corner和点_eye_right_corner
    double A, B, C;
    if (_eye_left_corner.x == _eye_right_corner.x) {
        A = 1;
        B = 0;
        C = -_eye_right_corner.x;
    }else {
        A = - (_eye_right_corner.y - _eye_left_corner.y) / (_eye_right_corner.x - _eye_left_corner.x);
        B = 1;
        C = - (_eye_right_corner.y + A * _eye_right_corner.x);
    }
    
    //直线2：-(1/A)x + By + C2 = 0; 经过点_eye_left_corner
    double C2 = -(_eye_left_corner.y - (1/A)*_eye_left_corner.x);
    
    //直线3：-(1/A)x + By + C3 = 0; 经过点_eye_right_corner
    double C3 = -(_eye_right_corner.y - (1/A)*_eye_right_corner.x);
    
    //直线4：-(1/A)x + By + C4 = 0; 经过点_eye_left_corner和_eye_right_corner的中点
    double C4 = -((_eye_left_corner.y + _eye_right_corner.y) * 0.5 -
                   (1/A)*(_eye_left_corner.x + _eye_right_corner.x) * 0.5);
    
    //_eye_top到直线一的距离
    double topDist = fabs(A*_eye_top.x + B*_eye_top.y + C) / sqrt(A * A + B * B);
    //_eye_bottom到直线一的距离
    double bottomDist = fabs(A*_eye_bottom.x + B*_eye_bottom.y + C) / sqrt(A * A + B * B);

    //渐变拉伸
    double percent;
    //处理边界问题
    double edgeRate;
    //用于判断点移动的方向
    double move_direction;
    if (A > 0) {
        move_direction = 1;
    }else {
        move_direction = -1;
    }
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        
        //点到直线一的距离
        double dist1 = fabs(A*x + B*y + C) / sqrt(A * A + B * B);
        
        if ((-(1/A) * x + B * y + C2)*(C2 - C3) >= 0 &&
            (-(1/A) * x + B * y + C3) * (C2 - C3) <= 0)
        {
            //点到直线四的距离
            double dist4 = fabs(-(1/A) * x + B * y + C4) / sqrt((1/A)*(1/A) + B * B);
            
            edgeRate = 1 - 2 * dist4 / sqrt((_eye_left_corner.x - _eye_right_corner.x)*(_eye_left_corner.x - _eye_right_corner.x) + (_eye_left_corner.y - _eye_right_corner.y)*(_eye_left_corner.y - _eye_right_corner.y));
            
            edgeRate = sqrt(edgeRate);
            edgeRate = sqrt(edgeRate);
            
            if (A < 0) {
                edgeRate = edgeRate * -1;
            }
            
            if (A*x + B*y + C > 0) {
                if (dist1 < topDist) {
                    attrArr[i * 5] -= edgeRate * dist1 * B / sqrt((1/A)*(1/A) + B*B) * move_direction;
                    attrArr[i * 5 + 1] -= edgeRate * dist1 * (1/A) / sqrt((1/A)*(1/A) + B*B) * move_direction;
                }else if (dist1 < dist + topDist - bottomDist) {
                    percent = topDist / dist1;
                    
                    attrArr[i * 5] -= edgeRate * percent * topDist * B / sqrt((1/A)*(1/A) + B*B) * move_direction;
                    attrArr[i * 5 + 1] -= edgeRate * percent * topDist * (1/A) / sqrt((1/A)*(1/A) + B*B) * move_direction;
                }
            }else if (A*x + B*y + C < 0 && dist1 < bottomDist) {
                attrArr[i * 5] += dist1 * B / sqrt((1/A)*(1/A) + B*B) * move_direction;
                attrArr[i * 5 + 1] += dist1 * (1/A) / sqrt((1/A)*(1/A) + B*B) * move_direction;
            }
        }
        attrArr[i * 5 + 1] *= (1/aspectRatio);
    }
}


void tj_curve_eyebrow(GLfloat *attrArr, GLuint rectLength, double ImgWidth, double ImgHeight, TJ_GLPoint eye_top, TJ_GLPoint eyebrow_upper_middle, TJ_GLPoint eyebrow_lower_middle, TJ_GLPoint eyebrow_left_corner, TJ_GLPoint eyebrow_right_corner)
{
    double aspectRatio = 1.0 * ImgHeight / ImgWidth;
    
    //坐标变换
    TJ_GLPoint _eye_top, _eyebrow_upper_middle, _eyebrow_lower_middle, _eyebrow_left_corner, _eyebrow_right_corner;
    
    _eye_top.x = eye_top.x / ImgWidth * 2 - 1;
    _eye_top.y = aspectRatio - eye_top.y / ImgWidth * 2;
    
    _eyebrow_upper_middle.x = eyebrow_upper_middle.x / ImgWidth * 2 - 1;
    _eyebrow_upper_middle.y = aspectRatio - eyebrow_upper_middle.y / ImgWidth * 2;
    
    _eyebrow_lower_middle.x = eyebrow_lower_middle.x / ImgWidth * 2 - 1;
    _eyebrow_lower_middle.y = aspectRatio - eyebrow_lower_middle.y / ImgWidth * 2;
    
    _eyebrow_left_corner.x = eyebrow_left_corner.x / ImgWidth * 2 - 1;
    _eyebrow_left_corner.y = aspectRatio - eyebrow_left_corner.y / ImgWidth * 2;
    
    _eyebrow_right_corner.x = eyebrow_right_corner.x / ImgWidth * 2 - 1;
    _eyebrow_right_corner.y = aspectRatio - eyebrow_right_corner.y / ImgWidth * 2;

    double move_dist = move_dist = sqrt((_eyebrow_left_corner.x - _eyebrow_right_corner.x)*(_eyebrow_left_corner.x - _eyebrow_right_corner.x) + (_eyebrow_left_corner.y - _eyebrow_right_corner.y)*(_eyebrow_left_corner.y - _eyebrow_right_corner.y)) * 0.2;

    //眉毛的最左边到眉毛的最右边的距离
    double totalDist = sqrt(2) * sqrt((_eyebrow_left_corner.x - _eyebrow_right_corner.x)*(_eyebrow_left_corner.x - _eyebrow_right_corner.x) + (_eyebrow_left_corner.y - _eyebrow_right_corner.y)*(_eyebrow_left_corner.y - _eyebrow_right_corner.y));
    
    //直线：Ax + By + C = 0;
    //方向：_eye_left_corner指向_eye_right_corner
    //经过点_eye_top与_eyebrow_lower_middle的中点
    TJ_GLPoint point1;
    point1.x = (_eye_top.x + _eyebrow_lower_middle.x) * 0.5;
    point1.y = (_eye_top.y + _eyebrow_lower_middle.y) * 0.5;
    double A, B, C;
    if (_eyebrow_left_corner.x == _eyebrow_right_corner.x) {
        A = 1;
        B = 0;
        C = -point1.x;
    }else {
        A = - (_eyebrow_left_corner.y - _eyebrow_right_corner.y) / (_eyebrow_left_corner.x - _eyebrow_right_corner.x);
        B = 1;
        C = - (point1.y + A * point1.x);
    }
    
    //直线2：Ax + By + C2 = 0; 经过点_eyebrow_right_corner
    double C2 = -(_eyebrow_right_corner.y + A*_eyebrow_right_corner.x);
    
    //直线3：-(1/A)x + By + C3 = 0; 经过点_eyebrow_left_corner 朝(-A, 1)的反方向移动0.1*self.move_dist
    double C3 = -(_eyebrow_left_corner.y - (1/A)*_eyebrow_left_corner.x);
    
    //直线4：-(1/A)x + By + C4 = 0; 经过点_eyebrow_right_corner和_right_eyebrow_left_corner的中点
    TJ_GLPoint point4;
    point4.x = _eyebrow_right_corner.x + 0.2 * (_eyebrow_right_corner.x - _eyebrow_left_corner.x);
    point4.y = _eyebrow_right_corner.y + 0.2 * (_eyebrow_right_corner.y - _eyebrow_left_corner.y);
    double C4 = -(point4.y - (1/A)*point4.x);
    
    //移动的方向
    int move_direction;
    if (A > 0) {
        move_direction = 1;
    }else {
        move_direction = -1;
    }
    
    for (int i = 0; i < rectLength; i++)
    {
        attrArr[i * 5 + 1] *= aspectRatio;
        
        float x = attrArr[i * 5];
        float y = attrArr[i * 5 + 1];
        
        //点到直线一的距离
        double dist00 = fabs(A*x + B*y + C2) / sqrt(A*A + B*B);
        
        //点到眉毛最右边的距离
        double dist11 = sqrt((x - _eyebrow_right_corner.x)*(x - _eyebrow_right_corner.x) + (y - _eyebrow_right_corner.y)*(y - _eyebrow_right_corner.y));
        
        double percent = (move_dist * 3 - dist00) / (move_dist * 3);
        if (percent < 0) {
            percent = 0;
        }
        percent = sqrt(percent);
        
        double percent2 =(totalDist - dist11) / totalDist;
        if (percent2 < 0) {
            percent2 = 0;
        }
        
        if ((A * x + B * y + C)*(C - C2) > 0 &&
            (-(1/A) * x + B * y + C3)*(C3 - C4) > 0 &&
            (-(1/A) * x + B * y + C4) * (C3 - C4) < 0 &&
            dist00 < move_dist * 3)
        {
            if (dist00 < sqrt((_eyebrow_upper_middle.x - _eyebrow_lower_middle.x)*(_eyebrow_upper_middle.x - _eyebrow_lower_middle.x) + (_eyebrow_upper_middle.y - _eyebrow_lower_middle.y)*(_eyebrow_upper_middle.y - _eyebrow_lower_middle.y))) {
                attrArr[i * 5] += percent2 * move_dist * B / sqrt((1/A) * (1/A) + B * B) * move_direction;
                attrArr[i * 5 + 1] += percent2 * move_dist * (B/A) / sqrt((1/A) * (1/A) + B * B) * move_direction;
                
            }else {
                attrArr[i * 5] += percent2 * percent * move_dist * B / sqrt((1/A) * (1/A) + B * B) * move_direction;
                attrArr[i * 5 + 1] += percent2 * percent * move_dist * (1/A) / sqrt((1/A) * (1/A) + B * B) * move_direction;
            }
        }
        attrArr[i * 5 + 1] *= (1 / aspectRatio);
    }
}





