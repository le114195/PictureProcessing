//
//  OpencvSVM.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/1/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "opencv2/opencv.hpp"
#import "opencv2/core/core.hpp"
#import "opencv2/highgui/highgui.hpp"
#import "opencv2/objdetect/objdetect.hpp"
#import <opencv2/imgcodecs/ios.h>

#import "opencv2/ml/ml.hpp"

#import "OpencvSVM.h"


using namespace cv;

@implementation OpencvSVM


+ (void)ml_svm
{
    
    float labels[4] = {1.0, -1.0, -1.0, -1.0};
    Mat labelsMat(3, 1, CV_32FC1, labels);
    
    float trainingData[4][2] = { {501, 10}, {255, 10}, {501, 255}, {10, 501} };
    Mat trainingDataMat(3, 2, CV_32FC1, trainingData);
    
    
    
    Ptr<ml::SVM> svm = ml::SVM::create();
    
    // edit: the params struct got removed,
    // we use setter/getter now:
    svm->setType(ml::SVM::C_SVC);
    svm->setKernel(ml::SVM::POLY);
    svm->setGamma(3);
    
    Ptr<ml::TrainData> tData = ml::TrainData::create(trainingDataMat, ml::SampleTypes::ROW_SAMPLE, labelsMat);
    svm->train(tData);
    // ...
    Mat query(3, 2, CV_32FC1, trainingData); // input, 1channel, 1 row (apply reshape(1,1) if nessecary)
    Mat res;   // output
    svm->predict(query, res);
    
    
    for (int i = 0; i < res.rows; i++) {
        for (int j = 0; j < res.cols; j++) {
            printf("- - -%d\n", res.at<uchar>(i, j));
        }
    }
}



@end
