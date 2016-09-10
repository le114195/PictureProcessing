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
            rgba[3] = 0;
        }
    }
    return srcMat;
}

Mat TJDraw::createOneGalleryimg(cv::Size size)
{
    Mat srcMat = Mat::zeros(size, CV_8UC1);
    for (int i = 0; i < srcMat.rows; i++) {
        for (int j = 0; j < srcMat.cols; j++) {
            srcMat.at<uchar>(i, j) = UCHAR_MAX;
        }
    }
    return srcMat;
}


cv::Point TJDraw::newPoint(cv::Point lastLocation, cv::Point location, double distance)
{
    double x0, y0, a, b, c, c0;
    double slope = 0; //斜率
    if (location.x == lastLocation.x) {
        x0 = location.x;
        if (location.y > lastLocation.y) {
            y0 = lastLocation.y + distance;
        }else {
            y0 = location.y + distance;
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
    return cv::Point(x0, y0);
}



double TJDraw::pointToLine(cv::Point point1, cv::Point point2, cv::Point point)
{
    double   d;
    if (point1.x == point2.x) {
        d = fabs(point.x - point2.x);
    }else {
        //直线方程：Ax + By + C = 0
        double a, b, c;
        b = -1;
        a = 1.0 * (point1.y - point2.y) / (point1.x - point2.x);
        c = point1.y - a * point1.x;
        d = fabs(a*point.x + b*point.y +c)/sqrt(a*a + b*b);
    }
    return d;
}


void TJDraw::drawCircle(cv::Mat &srcMat, cv::Point center, float r)
{
    for (int i = center.y - r; i < center.y + r; i++) {
        for (int j = center.x - r; j < center.x + r; j++) {
            
            if (i < 0 || j < 0 || j > srcMat.cols || i > srcMat.rows) {
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
    int cc = srcMat.channels();
    for (int i = center.y - r; i < center.y + r; i++) {
        if (i < 0 || i > srcMat.rows) {
            return;
        }
        uchar *data = srcMat.ptr<uchar>(i);
        for (int j = center.x -r ; j < center.x + r; j++) {
            if (j < 0 || j > srcMat.cols) {
                return;
            }
            if (hypot(std::abs(j - center.x), std::abs(i - center.y)) < r){
                for (int k = 0; k < cc; k++) {
                    if (k == 3) {
                        data[j * cc + k] = UCHAR_MAX;
                    }else {
                        data[j * cc + k] = 0;
                    }
                }
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
    }else if (point1.y == point2.y){
        for (int j = min(point1.x, point2.x); j < max(point1.x, point1.x); j++) {
            this->drawCircleFill(srcMat, cv::Point(j, point1.y), width * 0.5);
        }
    }else {
        double d = 0;
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








