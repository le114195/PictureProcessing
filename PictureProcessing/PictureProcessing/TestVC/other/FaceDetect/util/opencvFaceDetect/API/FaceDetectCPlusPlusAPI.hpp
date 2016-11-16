//
//  FaceDetectCPlusPlusAPI.hpp
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef FaceDetectCPlusPlusAPI_hpp
#define FaceDetectCPlusPlusAPI_hpp

#include <stdio.h>
#include <string>
#include <math.h>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>


class FaceDetectCPlusPlusAPI {
    
public:
    // 分类器路径
    const std::string file_name_frontalface = "haarcascade_frontalface_alt2.xml";
    const std::string file_name_left_eye = "haarcascade_mcs_lefteye.xml";
    const std::string file_name_right_eye = "haarcascade_mcs_righteye.xml";
    const std::string file_name_nose = "haarcascade_mcs_nose.xml";
    const std::string file_name_mouth = "haarcascade_mcs_mouth.xml";
    
    
    cv::Mat image;
    
    
    int detectFeature(CvRect featureROI, cv::Rect* feature_box, std::string filePath);
    
    
    
    
private:
    
    
    
    
    
    
};






#endif /* FaceDetectCPlusPlusAPI_hpp */
