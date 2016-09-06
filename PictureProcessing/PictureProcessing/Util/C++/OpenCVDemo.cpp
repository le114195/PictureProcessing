//
//  OpenCVDemo.cpp
//  openCV
//
//  Created by 勒俊 on 16/8/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "OpenCVDemo.hpp"



//TJMorphology
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/** 膨胀：求局部最大值 */
Mat TJMorphology::dilate_demo(const char *imgName, cv::Size size)
{
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    Mat element = getStructuringElement(MORPH_RECT, size);
    
    dilate(srcMat, dstMat, element);
    
    converBGR2RGB(dstMat);
    
    return dstMat;
}


/** 腐蚀：求局部最小值 */
Mat TJMorphology::erode_demo(const char *imgName, cv::Size size)
{
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    Mat element = getStructuringElement(MORPH_RECT, size);
    
    erode(srcMat, dstMat, element);
    
    converBGR2RGB(dstMat);
    
    return dstMat;
}


/** 形态学 */
Mat TJMorphology::morphologyEx_demo(const char *imgName, cv::Size size){
    
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    Mat element = getStructuringElement(MORPH_RECT, size);
    
    morphologyEx(srcMat, dstMat, MORPH_GRADIENT, element);
    
    converBGR2RGB(dstMat);
    
    return dstMat;
}



/** 开运算:把小的亮点变暗点 */
Mat TJMorphology::open_demo(const char* imgName, int size)
{
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    Mat element = getStructuringElement(MORPH_RECT, cv::Size(size * 2 + 1, size * 2 + 1), cv::Point(size, size));
    morphologyEx(srcMat, dstMat, MORPH_OPEN, element);
    converBGR2RGB(dstMat);
    
    return dstMat;
}



Mat TJMorphology::close_demo(const char* imgName, int size)
{
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    Mat element = getStructuringElement(MORPH_CROSS, cv::Size(size * 2 + 1, size * 2 + 1), cv::Point(size, size));
    morphologyEx(srcMat, dstMat, MORPH_CLOSE, element);
    converBGR2RGB(dstMat);
    
    return dstMat;
}



//TJScale
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/** size放大的倍数 */
Mat TJScale::resize_demo(const char *imgName, float size){
    
    Mat srcMat = imread(imgName, -1);
    Mat dstMat;
    resize(srcMat, dstMat, cv::Size(srcMat.cols*size, srcMat.rows*size));
    cvtColor(dstMat, dstMat, CV_RGBA2BGRA);
    return dstMat;
}


Mat TJScale::color_demo(const char *imgName){
    
    Mat srcMat = imread(imgName);
    Mat dstMat;
    
    
    
    
    
    
    
    return dstMat;
}


Mat TJScale::ROI_demo(const char *imgName) {
    
    Mat srcMat = imread(imgName);
    Mat logoMat = this->resize_demo(imgName, 2);
    Mat imgROI = srcMat(Rect(0, 0, logoMat.cols, logoMat.rows));
    
    for (int i = 0; i < logoMat.rows; ++i) {
        for (int j = 0; j < logoMat.cols; ++j) {
            Vec3b& rgba = imgROI.at<Vec3b>(i, j);
            rgba[0] = logoMat.at<Vec3b>(i, j)[0];
            rgba[1] = logoMat.at<Vec3b>(i, j)[1];
            rgba[2] = logoMat.at<Vec3b>(i, j)[2];
        }
    }
    converBGR2RGB(srcMat);
    return srcMat;
}






//TJEdge
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

Mat TJEdge::canny_demo(const char *imgName) {
    
    Mat srcMat, edgeMat, dstMat, grayMat;
    
    srcMat = imread(imgName);
    
    dstMat.create(srcMat.size(), srcMat.type());
    
    //将原图转换为灰度图像
    cvtColor(srcMat, grayMat, COLOR_BGR2GRAY);
    
    //使用3*3内核降噪
    blur(grayMat, edgeMat, cv::Size(5, 5));
    
    //使用Canny算子
    Canny(edgeMat, edgeMat, 3, 9, 3);
    
    
    //将dstMat中所有像素值都设置为0
    dstMat = Scalar::all(0);
    
    
    //将Canny算子输出的边缘图edgeMat作为掩码，来将原图srcMat拷贝到dstMat中
    srcMat.copyTo(dstMat, edgeMat);
    
    return dstMat;
}


//TJBlend
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/





Mat TJBlend::linearBlending(const char *imgName1, const char *imgName2)
{
    Mat srcImg, src1Img, src2Img, dstImg;
    
    srcImg = imread(imgName1);
    src1Img = srcImg(Rect(0, 0, srcImg.cols * 0.25, srcImg.rows * 0.25));
    src2Img = imread(imgName2);
    resize(src2Img, src2Img, cv::Size(src1Img.cols, src1Img.rows));
    
    double alphaValue = 0.3;
    double betaValue;
    
    betaValue = 1 - alphaValue;
    addWeighted(src1Img, alphaValue, src2Img, betaValue, 0.0, dstImg);
    
    for (int i = 0; i < dstImg.rows; ++i) {
        for (int j = 0; j < dstImg.cols; ++j) {
            Vec3b& rgba = srcImg.at<Vec3b>(i, j);
            rgba[0] = dstImg.at<Vec3b>(i, j)[0];
            rgba[1] = dstImg.at<Vec3b>(i, j)[1];
            rgba[2] = dstImg.at<Vec3b>(i, j)[2];
        }
    }
    converBGR2RGB(srcImg);
    return srcImg;
}


Mat TJBlend::linearBlending1(const char *imgName1, const char *imgName2)
{
    Mat src1Img, src2Img, dstImg;
    
    src1Img = imread(imgName1);
    src2Img = imread(imgName2);
    resize(src2Img, src2Img, cv::Size(src1Img.cols, src1Img.rows));
    
    double alphaValue = 0.2;
    double betaValue;
    
    betaValue = 1 - alphaValue;
    addWeighted(src1Img, alphaValue, src2Img, betaValue, 0.0, dstImg);
    
    converBGR2RGB(dstImg);
    return dstImg;
}







