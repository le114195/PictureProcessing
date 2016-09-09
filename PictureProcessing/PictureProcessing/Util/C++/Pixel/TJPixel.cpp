//
//  TJPixel.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "TJPixel.hpp"


/*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


void TJPixel::at_demo(const char *imgName) {
    
    Mat srcImage = imread(imgName);
    
    if (srcImage.type() == CV_8UC1) {
        
        for (int i = 0; i < srcImage.cols; i++) {
            for (int j = 0; j < srcImage.rows; j++) {
                srcImage.at<uchar>(j, i);
            }
        }
    }else if (srcImage.type() == CV_8UC3) {
        for (int i = 0; i < srcImage.cols; i++) {
            for (int j = 0; j < srcImage.rows; j++) {
                srcImage.at<cv::Vec3b>(j, i)[0];
                srcImage.at<cv::Vec3b>(j, i)[1];
                srcImage.at<cv::Vec3b>(j, i)[2];
            }
        }
    }
}


/** 指针访问像素 */
void TJPixel::ptr_demo(const char *imgName) {
    Mat srcImage = imread(imgName);
    
    int rows = srcImage.rows;
    int cols = srcImage.cols * srcImage.channels();
    
    for (int j = 0; j < cols; j++) {
        
        uchar *data = srcImage.ptr<uchar>(j);
        for (int i = 0; i < rows; i++) {
            
            
            
            
        }
    }
}



/** 迭代器访问像素 */
void TJPixel::iterator_demo(const char *imgName) {
    
    Mat srcImage = imread(imgName);
    cv::Mat_<cv::Vec3b>::iterator it = srcImage.begin<cv::Vec3b>();
    cv::Mat_<cv::Vec3b>::iterator itend = srcImage.end<cv::Vec3b>();
    
    while (it!=itend) {
        
        //        (*it)[0]
        //        (*it)[1]
        //        (*it)[2]
        
        it++;
    }
}


Mat TJPixel::oneGallery(const char *imgName) {
    
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), CV_8UC1);
    
    for (int i = 0; i < srcMat.rows; ++i) {
        for (int j = 0; j < srcMat.cols; ++j) {
            if (srcMat.type() == CV_8UC1) {
                dstMat.at<uchar>(i, j) = srcMat.at<uchar>(i, j);
            }else if (srcMat.type() == CV_8UC2) {
                dstMat.at<uchar>(i, j) = srcMat.at<Vec2b>(i, j)[0];
            }else if (srcMat.type() == CV_8UC3) {
                dstMat.at<uchar>(i, j) = (srcMat.at<Vec3b>(i, j)[0] + srcMat.at<Vec3b>(i, j)[1] + srcMat.at<Vec3b>(i, j)[2]) / 3;
            }else if (srcMat.type() == CV_8UC4) {
                dstMat.at<uchar>(i, j) = (srcMat.at<Vec4b>(i, j)[0] + srcMat.at<Vec4b>(i, j)[1] + srcMat.at<Vec4b>(i, j)[2]) / 3;
            }
        }
    }
    return dstMat;
}

Mat TJPixel::colorReversal(const char* imgName){
    
    Mat srcMat = oneGallery(imgName);
    
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    
    for (int i = 0; i < srcMat.rows; i++) {
        
        for (int j = 0; j < srcMat.cols; j++) {
            
            dstMat.at<uchar>(i, j) = UCHAR_MAX - srcMat.at<uchar>(i, j);
        }
    }
    return dstMat;
}


/** 将一张图片转成PNG图片 */
Mat TJPixel::createPngWithRgb(const char* imgName)
{
    Mat srcMat = imread(imgName, -1);

    Mat dstMat = Mat::zeros(srcMat.size(), CV_8UC4);
    
    for (int i = 0; i < srcMat.rows; i++) {
        for (int j = 0; j < srcMat.cols; j++) {
            Vec4b &rgba = dstMat.at<Vec4b>(i, j);
            rgba[0] = srcMat.at<Vec4b>(i, j)[0];
            rgba[1] = srcMat.at<Vec4b>(i, j)[1];
            rgba[2] = srcMat.at<Vec4b>(i, j)[2];
            
            rgba[3] = UCHAR_MAX;
        }
    }
    cvtColor(dstMat, dstMat, CV_RGBA2BGRA);
    return dstMat;
}


/** 将图片放缩 */
Mat TJPixel::resize_demo(Mat &srcMat, float size){
    Mat dstMat;
    resize(srcMat, dstMat, cv::Size(srcMat.cols*size, srcMat.rows*size));
    cvtColor(dstMat, dstMat, CV_RGBA2BGRA);
    return dstMat;
}





Mat TJPixel::createPngImg(cv::Size size)
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

void TJPixel::drawCircle(cv::Mat &srcMat, cv::Point center, float r)
{
    if (center.x == 0 && center.y == 0) {
        return;
    }
    
    if (center.y < 0) {
        center.y = 0;
    }else if (center.y > srcMat.rows) {
        center.y = srcMat.rows;
    }
    
    if (center.x < 0) {
        center.x = 0;
    }else if (center.x > srcMat.cols) {
        center.x = srcMat.cols;
    }
    
    for (int i = center.y - r; i < center.y + r; i++) {
        for (int j = center.x - r; j < center.x + r; j++) {
            if (i + 1 > srcMat.rows || i - 1 < 0 || j - 1 < 0 || j + 1 > srcMat.cols) {
                continue;
            }
            Vec4b &rgba = srcMat.at<Vec4b>(i, j);
            if (hypot(std::abs(j - center.x), std::abs(i - center.y)) < r) {
                float xx = (rand() % 10) * 0.1;
                uchar value = UCHAR_MAX * xx;
                
                rgba[0] = value;
                rgba[1] = value;
                rgba[2] = value;
                rgba[3] = UCHAR_MAX;
            }

        }
    }
}









