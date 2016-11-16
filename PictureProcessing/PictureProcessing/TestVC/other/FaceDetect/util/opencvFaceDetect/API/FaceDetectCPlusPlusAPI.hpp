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
#include "FaceFeature.hpp"


class FaceDetectCPlusPlusAPI {
    
public:
    // 分类器路径
    const std::string file_name_frontalface = "haarcascade_frontalface_alt2.xml";
    const std::string file_name_left_eye = "haarcascade_mcs_lefteye.xml";
    const std::string file_name_right_eye = "haarcascade_mcs_righteye.xml";
    const std::string file_name_nose = "haarcascade_mcs_nose.xml";
    const std::string file_name_mouth = "haarcascade_mcs_mouth.xml";
    

    /// the image to be displayed,shows rectangles around detected features.
    cv::Mat displayImage;
    
    /// the image obtained after coloring the flood filled pixels as blue
    cv::Mat floodfillImage;
    
    std::string basePath;
    
    cv::Rect faceRect;
    
    /// the bounding box of the left eye
    cv::Rect eyeLeftRect;
    
    /// the bounding box of the right eye.
    cv::Rect eyeRightRect;
    
    /// the bounding box of the mouth
    cv::Rect mouthRect;
    
    /// the bounding box of the nose
    cv::Rect noseRect;

    
    cv::Mat image;
    
    
    FaceDetectCPlusPlusAPI(cv::Mat img, std::string dirPath);
    
    
    void findFace();
    
    
    void findLeftEye();
    
    
    void findRightEye();
    
    
    void findNose();
    
    
    void findMouth();

    
    int detectFeature(CvRect featureROI, FaceFeature face_feature, cv::Rect* feature_box, std::string filePath);
    
    
    
    
private:
    
    
    
    
    
    
};






#endif /* FaceDetectCPlusPlusAPI_hpp */
