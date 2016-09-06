//
//  OpenCVDemo.hpp
//  openCV
//
//  Created by 勒俊 on 16/8/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef OpenCVDemo_hpp
#define OpenCVDemo_hpp

#include "TJOpencvBase.hpp"

#endif /* OpenCVDemo_hpp */







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
    Mat resize_demo(const char *imgName, float size);
    
    
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




/** Blending：混合 */
class TJBlend:public TJOpenCVBase {
    
public:
    
    /** 线性混合 */
    Mat linearBlending(const char* imgName1, const char* imgName2);
    
    /** 线性混合2 */
    Mat linearBlending1(const char* imgName1, const char* imgName2);
    
    
    
private:
    
    
    
    
};








