//
//  Draw.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/9.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "Draw.hpp"



Mat TJDraw::createPngImg(cv::Size size)
{
    Mat srcMat = Mat::zeros(size, CV_8UC4);
    for (int i = 0; i < srcMat.rows; i++) {
        for (int j = 0; j < srcMat.cols; j++) {
            Vec4b &rgba = srcMat.at<Vec4b>(i, j);
            rgba[0] = UCHAR_MAX;
            rgba[1] = UCHAR_MAX;
            rgba[2] = UCHAR_MAX;
            rgba[3] = UCHAR_MAX;
        }
    }
    return srcMat;
}


float TJDraw::pointToLine(cv::Point point1, cv::Point point2, cv::Point point)
{
    float   d;
    if (point1.x == point2.x) {
        d = fabs(point.x - point2.x);
    }else {
        //直线方程：Ax + By + C = 0
        float a, b, c;
        b = -1;
        a = (float)(point1.y - point2.y) / (point1.x - point2.x);
        c = point1.y - a * point1.x;
        d = fabs(a*point.x + b*point.y +c)/sqrt(a*a + b*b);
    }
    return d;
}


void TJDraw::drawCircle(cv::Mat &srcMat, cv::Point center, float r)
{
    for (int i = center.y - r; i < center.y + r; i++) {
        for (int j = center.x - r; j < center.x + r; j++) {
            
            if (i < 0 || j < 0 || i > srcMat.cols || j > srcMat.rows) {
                return;
            }
            
            Vec4b &rgba = srcMat.at<Vec4b>(i, j);
            if (hypot(std::abs(j - center.x), std::abs(i - center.y)) < r) {
                float xx = (rand() % 10) * 0.1;
                float value = UCHAR_MAX * xx;
                
                rgba[0] = value;
                rgba[1] = value;
                rgba[2] = value;
                rgba[3] = UCHAR_MAX;
            }
        }
    }
}


void TJDraw::drawCircleFill(cv::Mat &srcMat, cv::Point center, float r)
{
    for (int i = center.y - r; i < center.y + r; i++) {
        for (int j = center.x - r; j < center.x + r; j++) {
            if (i < 0 || j < 0 || i > srcMat.cols || j > srcMat.rows) {
                return;
            }
            
            Vec4b &rgba = srcMat.at<Vec4b>(i, j);
            if (hypot(std::abs(j - center.x), std::abs(i - center.y)) < r) {
                rgba[0] = 0;
                rgba[1] = 0;
                rgba[2] = 0;
                rgba[3] = UCHAR_MAX;
            }
        }
    }
}



void TJDraw::drawLine(cv::Mat &srcMat, cv::Point point1, cv::Point point2, float width)
{
    if (point1.x == point2.x) {
        for (int i = min(point1.y, point2.y); i < max(point1.y, point2.y); i++) {
            this->drawCircleFill(srcMat, cv::Point(point1.x, i), width * 0.5);
        }
    }else {
        float d = 0;
        for (int i = min(point1.y, point2.y); i < max(point1.y, point2.y); i++) {
            for (int j = min(point1.x, point2.x); j < max(point1.x, point2.x); j++) {
                d = this->pointToLine(point1, point2, cv::Point(j, i));
                
                if (d < 0.5) {
                    this->drawCircleFill(srcMat, cv::Point(j, i), width * 0.5);
                }
            }
        }
    }
}








