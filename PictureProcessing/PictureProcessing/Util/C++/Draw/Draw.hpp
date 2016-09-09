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
    
    /** 获得一张png图片 */
    Mat createPngImg(cv::Size size);
    
    /** 已知半径和圆心画一个圆 */
    void drawCircle(Mat &srcMat, cv::Point center, float r);
    
    
    
    /**
     *  画一条直线
     *
     *  @param srcMat 地图
     *  @param point1 点1
     *  @param point2 点2
     *  @param width  线的宽度
     */
    void drawLine(Mat &srcMat, cv::Point point1, cv::Point point2, float width);
    
    
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
    float pointToLine(cv::Point point1, cv::Point point2, cv::Point point);
    
    
private:
    
    
    
    
    
};
















#endif /* Draw_hpp */
