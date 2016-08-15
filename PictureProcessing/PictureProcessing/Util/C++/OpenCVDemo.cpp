//
//  OpenCVDemo.cpp
//  openCV
//
//  Created by 勒俊 on 16/8/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "OpenCVDemo.hpp"



//TJOpenCVBase

Mat TJOpenCVBase::showImage(const char *imageName)
{
    Mat srcMat = imread(imageName);
    cvtColor(srcMat, srcMat, CV_BGR2RGB);
    return srcMat;
}

void TJOpenCVBase::converBGR2RGB(cv::Mat dstMat)
{
    cvtColor(dstMat, dstMat, CV_BGR2RGB);
}



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
            uchar pixel = data[i];
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



/** 将图片变成灰度图片 */
Mat TJPixel::resetPixel(const char *imgName) {
    
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), srcMat.type());
    if (srcMat.type() == CV_8UC1) {
        
        for (int i = 0; i < srcMat.cols; i++) {
            for (int j = 0; j < srcMat.rows; j++) {
                dstMat.at<uchar>(j, i) = srcMat.at<uchar>(j, i);
            }
        }
    }else if (srcMat.type() == CV_8UC3) {
        for (int i = 0; i < srcMat.cols; i++) {
            for (int j = 0; j < srcMat.rows; j++) {
                
                uchar av = (srcMat.at<cv::Vec3b>(j, i)[0] + srcMat.at<cv::Vec3b>(j, i)[1] + srcMat.at<cv::Vec3b>(j, i)[2]) / 3;
                
                dstMat.at<cv::Vec3b>(j, i)[0] = av;
                dstMat.at<cv::Vec3b>(j, i)[1] = av;
                dstMat.at<cv::Vec3b>(j, i)[2] = av;
            }
        }
    }
    converBGR2RGB(dstMat);
    return dstMat;
}


/** 创建一张图片 */
void TJPixel::createAlphaMat(cv::Mat &mat) {
    
    for (int i = 0; i < mat.rows; ++i) {
        
        for (int j = 0; j < mat.cols; ++j) {
            
            Vec4b &rgba = mat.at<Vec4b>(i, j);
            rgba[0] = UCHAR_MAX;
            rgba[1] = saturate_cast<uchar>((float (mat.cols - j)) / ((float)mat.cols) *UCHAR_MAX);
            rgba[2] = saturate_cast<uchar>((float (mat.rows - i)) / ((float)mat.rows) *UCHAR_MAX);
            rgba[3] = saturate_cast<uchar>(0.5 * (rgba[1] + rgba[2]));
        }
    }
}


/** 将生成的图片保存到tool文件中 */
void TJPixel::createImage()
{
    
    
    
    
}

Mat TJPixel::cutImage(const char *imgName){
    
    Mat srcMat = imread(imgName);
    Mat dstMat = Mat::zeros(srcMat.size(), CV_8UC4);
    
    
    for (int i = 0; i < dstMat.rows; ++i) {
        
        for (int j = 0; j < dstMat.cols; ++j) {
            
            Vec4b& rgba = dstMat.at<Vec4b>(i, j);
            
            //            rgba[0] = srcMat.at<Vec3b>(i, j)[0];
            //            rgba[1] = srcMat.at<Vec3b>(i, j)[1];
            //            rgba[2] = srcMat.at<Vec3b>(i, j)[2];
            
            rgba[0] = UCHAR_MAX;
            rgba[1] = saturate_cast<uchar>((float (dstMat.cols - j)) / ((float)dstMat.cols) *UCHAR_MAX);
            rgba[2] = saturate_cast<uchar>((float (dstMat.rows - i)) / ((float)dstMat.rows) *UCHAR_MAX);
            rgba[3] = saturate_cast<uchar>(0.5 * (rgba[1] + rgba[2]));
            //            rgba[3] = 0;
            
        }
        
    }
    
    cvtColor(dstMat, dstMat, CV_RGB2BGR);
    
    return dstMat;
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

Mat TJScale::resize_demo(const char *imgName){
    
    Mat srcMat = imread(imgName);
    Mat dstMat;
    
    printf("width=%d---height=%d\n", srcMat.cols, srcMat.rows);
    
    resize(srcMat, dstMat, cv::Size(srcMat.cols/2, srcMat.rows/2));
    
    
    printf("width=%d---height=%d\n", dstMat.cols, dstMat.rows);
    
    
    converBGR2RGB(dstMat);
    
    return dstMat;
}


Mat TJScale::color_demo(const char *imgName){
    
    Mat srcMat = imread(imgName);
    Mat dstMat;
    
    
    
    
    
    
    
    return dstMat;
}


Mat TJScale::ROI_demo(const char *imgName) {
    
    Mat srcMat = imread(imgName);
    Mat logoMat = this->resize_demo(imgName);
    
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














