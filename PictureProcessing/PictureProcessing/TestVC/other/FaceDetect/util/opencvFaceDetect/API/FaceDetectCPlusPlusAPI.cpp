//
//  FaceDetectCPlusPlusAPI.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "FaceDetectCPlusPlusAPI.hpp"


FaceFeature face(1.1,2,0, cvSize(50,50));
FaceFeature left_eye(1.15, 3,0, cvSize(18,12));
FaceFeature right_eye( 1.15, 3,0,cvSize(18,12));
FaceFeature nose(1.2, 3,0,cvSize(18,12));
FaceFeature mouth(1.12, 3 ,0, cvSize(25,15));



FaceDetectCPlusPlusAPI::FaceDetectCPlusPlusAPI(cv::Mat img, std::string dirPath) {
    image = img;
    
    displayImage.create(image.rows, image.cols,CV_8UC3);
    image.copyTo(displayImage);
    
    floodfillImage.create(image.rows, image.cols,CV_8UC3);
    image.copyTo(image);
    
    basePath = dirPath;
}

void FaceDetectCPlusPlusAPI::findFace() {
    cv::Rect* rectptr = &faceRect;
    IplImage imgTmp = image;
    IplImage *imageIpl = cvCloneImage(&imgTmp);
    CvRect face_roi = cvGetImageROI(imageIpl);
    cvReleaseImage(&imageIpl);
    
    //加载分类器
    std::string filePath = basePath;
    filePath = filePath.append(file_name_frontalface);
    detectFeature(face_roi, face, rectptr, filePath);
}


void FaceDetectCPlusPlusAPI::findLeftEye() {
    cv::Rect* rectptr = &eyeLeftRect;
    CvRect left_eye_roi = cvRect(faceRect.x, faceRect.y + (faceRect.height / 4.5), faceRect.width / 2, faceRect.height / 2.5);
    
    std::string filePath = basePath;
    filePath = filePath.append(file_name_left_eye);
    detectFeature(left_eye_roi,left_eye,rectptr,filePath);
}

void FaceDetectCPlusPlusAPI::findRightEye() {
    cv::Rect* rectptr = &eyeRightRect;
    CvRect right_eye_roi = cvRect(faceRect.x + faceRect.width / 2, faceRect.y + (faceRect.height / 4.5), faceRect.width / 2, faceRect.height / 2.5);
    
    std::string filePath = basePath;
    filePath = filePath.append(file_name_right_eye);
    detectFeature(right_eye_roi,right_eye,rectptr,filePath);
}

void FaceDetectCPlusPlusAPI::findNose() {
    cv::Rect* rectptr = &noseRect;
    CvRect nose_roi = cvRect(faceRect.x, faceRect.y + (faceRect.height / 2.5), faceRect.width, faceRect.height / 2);
    
    std::string filePath = basePath;
    filePath = filePath.append(file_name_nose);
    detectFeature(nose_roi,nose,rectptr,filePath);
}

void FaceDetectCPlusPlusAPI::findMouth() {
    cv::Rect* rectptr = &mouthRect;
    CvRect mouth_roi = cvRect(faceRect.x, faceRect.y + (faceRect.height / 1.5), faceRect.width, faceRect.height / 3);
    
    std::string filePath = basePath;
    filePath = filePath.append(file_name_mouth);
    detectFeature(mouth_roi,mouth,rectptr,filePath);
}




int FaceDetectCPlusPlusAPI::detectFeature(CvRect featureROI, FaceFeature face_feature, cv::Rect* feature_box, std::string filePath) {
    
    CvMemStorage *storage = cvCreateMemStorage(0);
    IplImage imgTmp = image;
    IplImage *imageIpl = cvCloneImage(&imgTmp);
    cvSetImageROI(imageIpl, featureROI);
    CvSeq* feature;
    
    CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad(filePath.c_str(), NULL, NULL, NULL);
    feature = cvHaarDetectObjects(imageIpl, cascade, storage, face_feature.haarScaleFactor, face_feature.haarMinNeighbours, face_feature.haarFlags, face_feature.minFeatureSize);
    cvReleaseImage(&imageIpl);
    
    CvRect* r;
    int index_max_area;
    int x1, x2, y1, y2; // opposite vertices of the rectangle
    
    
    if (feature->total == 0) {
        return 0;
    }
    else {
        // find the rectangle with max area and assign it to that feature
        int x1_temp[feature->total];
        int y1_temp[feature->total];
        int x2_temp[feature->total];
        int y2_temp[feature->total];
        int area_temp[feature->total];
        index_max_area = 0;
        int max_area_temp = 0;
        for (int i = 0; i < (feature ? feature->total : 0); i++) {
            r = (CvRect*) cvGetSeqElem(feature, i);
            x1_temp[i] = r->x + featureROI.x;
            y1_temp[i] = r->y + featureROI.y;
            x2_temp[i] = x1_temp[i] + r->width;
            y2_temp[i] = y1_temp[i] + r->height;
            area_temp[i] = r->width * r->height;
            if (area_temp[i] > max_area_temp) {
                index_max_area = i;
                max_area_temp = area_temp[i];
            }
        }
        x1 = x1_temp[index_max_area];
        y1 = y1_temp[index_max_area];
        x2 = x2_temp[index_max_area];
        y2 = y2_temp[index_max_area];
        
        feature_box->x = x1;
        feature_box->y = y1;
        feature_box->width = abs(x2 - x1);
        feature_box->height = abs(y2 - y1);
        
        cv::rectangle(displayImage, cvPoint(x1, y1), cvPoint(x2, y2), CV_RGB(255, 0, 0), 1, 8, 0);
        
        return 0;
    }

    return 0;
}
