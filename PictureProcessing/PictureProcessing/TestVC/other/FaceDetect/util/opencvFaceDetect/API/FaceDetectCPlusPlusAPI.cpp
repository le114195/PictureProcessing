//
//  FaceDetectCPlusPlusAPI.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "FaceDetectCPlusPlusAPI.hpp"



int FaceDetectCPlusPlusAPI::detectFeature(CvRect featureROI, cv::Rect* feature_box, std::string filePath) {
    
    IplImage imgTmp = image;
    IplImage *imageIpl = cvCloneImage(&imgTmp);
    cvSetImageROI(imageIpl, featureROI);
    CvSeq* feature;
    
    CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad(filePath.c_str(), NULL, NULL, NULL);
    feature = cvHaarDetectObjects(imageIpl,
                                  cascade,
                                  storage,
                                  face_feature.haarScaleFactor,
                                  face_feature.haarMinNeighbours,
                                  face_feature.haarFlags,
                                  face_feature.minFeatureSize);
    cvReleaseImage(&imageIpl);

}
