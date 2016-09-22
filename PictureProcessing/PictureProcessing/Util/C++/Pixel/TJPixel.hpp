//
//  TJPixel.hpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef TJPixel_hpp
#define TJPixel_hpp

#include <stdio.h>
#include "TJOpencvBase.hpp"

#endif /* TJPixel_hpp */


/** 访问图片的像素操作 */
class TJPixel:public TJOpenCVBase {
    
public:
    
    //利用at函数访问像素
    void at_demo(const char* imgName);
    
    
    //利用指针访问像素
    void ptr_demo(const char* imgName);
    
    
    /** 迭代器访问像素 */
    void iterator_demo(const char* imgName);
    
    
    /** 将图片转成单通道黑白图片 */
    Mat oneGallery(const char* imgName);
    
    
    /** 将图片的像素灰度反转 */
    Mat colorReversal(const char* imgName);
    
    
    /** 将一张图片转成PNG图片 */
    Mat createPngWithRgb(const char* imgName);
    
    /** 将图片放缩 */
    Mat resize_demo(Mat &srcMat, float size);
    
    
    
    /** 获得一张png图片 */
    Mat createPngImg(cv::Size size);
    
    
    /** 已知半径和圆心画一个圆 */
    void drawCircle(Mat &srcMat, cv::Point center, float r);
    
    
    Mat drawTest2(Mat &srcMat, Mat &mapMat);
    
    
    
    
private:
    
    vector<int> xx;
    
    
    
};

