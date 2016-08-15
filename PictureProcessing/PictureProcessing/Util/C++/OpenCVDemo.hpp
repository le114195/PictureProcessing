//
//  OpenCVDemo.hpp
//  openCV
//
//  Created by 勒俊 on 16/8/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef OpenCVDemo_hpp
#define OpenCVDemo_hpp

#include <stdio.h>
#import <opencv2/opencv.hpp>

#endif /* OpenCVDemo_hpp */

using namespace cv;

class TJOpenCVBase{
    
public:
    
    Mat showImage(const char *imageName);
    
    static void converBGR2RGB(Mat dstMat);
    
protected:
    
    Mat srcImage;
    Mat dstImage;
    
private:
    
    
    
    
};



/** 访问图片的像素操作 */
class TJPixel:public TJOpenCVBase {
    
public:
    
    //利用at函数访问像素
    void at_demo(const char* imgName);
    
    
    //利用指针访问像素
    void ptr_demo(const char* imgName);
    
    
    /** 迭代器访问像素 */
    void iterator_demo(const char* imgName);
    
    
    /** 将图片变成灰度图片 */
    Mat resetPixel(const char* imgName);
    
    void createImage();
    
    Mat cutImage(const char* imgName);
    
    /** 将图片转成单通道黑白图片 */
    Mat oneGallery(const char* imgName);
    
    
    /** 将图片的像素灰度反转 */
    Mat colorReversal(const char* imgName);
    
private:
    
    void createAlphaMat(Mat &mat);
    
};




/** 形态学 */
class TJMorphology: public TJOpenCVBase{
    
public:
    
    
    
    /** 膨胀：求局部最大值 */
    static Mat dilate_demo(const char* imgName, cv::Size size);
    
    /** 腐蚀：求局部最小值 */
    static Mat erode_demo(const char* imgName, cv::Size size);
    
    
    /** 形态学 */
    static Mat morphologyEx_demo(const char* imgName, cv::Size size);
    
    
    /** 开运算:把小的亮点变暗点 */
    static Mat open_demo(const char* imgName, int size);
    
    /** 闭运算: */
    static Mat close_demo(const char* imgName, int size);
    
private:
    
    
    
};



/** 图片放缩 */
class TJScale: public TJOpenCVBase {
    
    
public:
    
    /** resize：图像放缩函数 */
    Mat resize_demo(const char* imgName);
    
    
    Mat color_demo(const char* imgName);
    
    
    Mat ROI_demo(const char *imgName);
    
    
    
protected:
    
    
    
    
private:
    
    
    
};



/** 边缘检测算法 */
class TJEdge:public TJOpenCVBase {
    
public:
    
    Mat canny_demo(const char* imgName);
    
    
    
    
};














