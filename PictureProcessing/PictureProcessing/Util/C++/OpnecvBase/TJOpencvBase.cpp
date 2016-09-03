//
//  TJOpencvBase.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "TJOpencvBase.hpp"


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


