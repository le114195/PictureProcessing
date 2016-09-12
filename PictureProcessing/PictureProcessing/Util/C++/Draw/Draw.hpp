//
//  Draw.hpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/9.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef Draw_hpp
#define Draw_hpp

#include <stdio.h>
#include "OpenCVDemo.hpp"


class TJDraw:public TJOpenCVBase{
    
  
public:
    
    /**
     *  构造方法
     */
    TJDraw(cv::Mat &tarMat, int size);
    
    /** 获得一张rgba图片 */
    Mat createPngImg(cv::Size size);
    
    
    /**
     *  获得一张单通道的图片
     *
     *  @param size 图片的大小
     *
     *  @return 返回图片矩阵
     */
    Mat createOneGalleryimg(cv::Size size);
    
    
    /**
     *  通过两个点获取第三个点，第三个点位于这两个点所组成的直线上，并且该点距离第一个点的距离为distance
     *
     *  @param lastLocation 第一个点
     *  @param location     第二个点
     *  @param distance     第三个点距第一个点的距离
     *
     *  @return 返回第三个点
     */
    cv::Point newPoint(cv::Point lastLocation, cv::Point location, double distance);
    
    
    
    /** 已知半径和圆心画一个圆 */
    void drawCircle(Mat &srcMat, cv::Point center, float r);
    
    
    /**
     *  画一个充满的圆
     *
     *  @param srcMat 输入背景图片
     *  @param center 圆心
     *  @param r      半径
     */
    void drawCircleFill(Mat &srcMat, cv::Point center, float r);
    
    
    /**
     *  点到直线的距离
     *
     *  @param point1、point2 点1和点2是直线上的两个点
     *
     *  @return 返回距离
     */
    double pointToLine(cv::Point point1, cv::Point point2, cv::Point point);
    
    /**
     *  画一个多边形
     *
     *  @param point  新输入的点
     *  @param srcMat 输入的图片
     *  @param width  线的宽度（像素）
     */
    void drawPolygon(cv::Point point, cv::Mat &srcMat, int width);
    
    /**
     *  将pointVec清空
     */
    void clearPointVec();
    
    
    /**
     *  画一个不规则的图形
     *
     *  @param srcMat 输入的图片
     *  @param point  不规则图片矩阵中心
     */
    void drawIrregular(cv::Mat &srcMat, cv::Point point);
    
    
    
    
private:
    
    vector<cv::Point> pointVec;
    
    Mat targetMat;
    
};
















#endif /* Draw_hpp */
