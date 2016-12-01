//
//  FaceLandmarkInterface.m
//  TJSDM
//
//  Created by 崔海港 on 2016/11/23.
//  Copyright © 2016年 崔海港. All rights reserved.
//

#import "opencv2/opencv.hpp"
#import "opencv2/core/core.hpp"
#import "opencv2/highgui/highgui.hpp"
#import "opencv2/objdetect/objdetect.hpp"
#import <opencv2/imgcodecs/ios.h>

#import "FaceLandmarkInterface.h"
#include "include/ldmarkmodel.h"

@implementation FaceLandmarkInterface

+(NSMutableArray *)getLanmarkPointFromUIImage:(UIImage *)faceImage{
    
    ldmarkmodel model;
    
    NSString *bundlePathString = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"%@",@"/"];
    std::string baseDir = [bundlePathString cStringUsingEncoding:NSASCIIStringEncoding];

    // 读入人脸检测模型
    std::string faceDetModelPath = baseDir;
    faceDetModelPath = faceDetModelPath.append("haar_roboman_ff_alt2.xml");
    model.loadFaceDetModelFile(faceDetModelPath);

    // 读入人脸关键点的模型
    std::string modelFilePath = baseDir;
    modelFilePath = modelFilePath.append("roboman-landmark-model.bin");
    
    if(!load_ldmarkmodel(modelFilePath, model)){
        NSLog(@"model not found!");
        
        return nil;
    }
    
    cv::Mat rsMat = [self TJUIImagetoMat:faceImage];
    
//    cv::Mat grayMat;
//    cv::cvtColor(rsMat, grayMat, CV_BGRA2GRAY);
//    UIImage *grayImage;
//    grayImage = MatToUIImage(grayMat);
    
    
    cv::Mat current_shape;
    model.track(rsMat, current_shape);
    cv::Vec3d eav;
    model.EstimateHeadPose(current_shape, eav);
    model.drawPose(rsMat, current_shape, 50);

    NSMutableArray *faceKeyPoint = [NSMutableArray array];
    
    int numLandmarks = current_shape.cols;
    
    for (int i = 0; i < numLandmarks; i++) {
        int position = current_shape.at<float>(i);
        NSString *strPosition = [NSString stringWithFormat:@"%d",position];
        [faceKeyPoint addObject:strPosition];
    }
    
    rsMat.release();
    current_shape.release();
    
    return faceKeyPoint;
}


+(CGRect)getSubstanceRect:(UIImage *)maskImage{
    
    CGRect rsRect;
    rsRect.origin.x = 0;
    rsRect.origin.y = 0;
    rsRect.size.width = 0;
    rsRect.size.width = 0;
    
    cv::Mat orMat = [self TJUIImagetoMat:maskImage];
    int paRW = orMat.rows;
    int paCL = orMat.cols;
    
    cv::Mat grayMat;
    cv::cvtColor(orMat, grayMat, CV_BGR2GRAY);
    orMat.release();
    
    int rb = paRW-1; int re = 0; int cb = paCL-1; int ce = 0;
    for(int r=0; r<paRW; r++)
    {
        for(int c=0; c<paCL; c++)
        {
            int value = grayMat.ptr<uchar>(r)[c];
            if(value>250)
            {
                if(r<rb) rb = r;
                if(r>re) re = r;
                if(c<cb) cb = c;
                if(c>ce) ce = c;
            }
        }
    }
    
    grayMat.release();
    
    int rl = re - rb;
    int cl = ce - cb;
    int v_ex = 20;
    
    rb = rb - v_ex;
    re = re + v_ex;
    cb = cb - v_ex;
    ce = ce + v_ex;
    
    if(rb<0) rb = 0;
    if(re>paRW-1) re = paRW-1;
    if(cb<0) cb = 0;
    if(ce>paCL-1) ce = paCL-1;
    
    rl = re - rb;
    cl = ce - cb;
    rsRect.origin.x = cb;
    rsRect.origin.y = rb;
    rsRect.size.width = cl + 1;
    rsRect.size.height = rl + 1;
    
    return rsRect;
}

/**
 UIImage转mat,mat变为3通道

 @param srcImage 原始UIImage
 @return 变换后的mat
 */
+(cv::Mat) TJUIImagetoMat:(UIImage *)srcImage{
    
    cv::Mat orMat;
    cv::Mat rsMat;
    
    // UIImage转Mat
    UIImageToMat(srcImage, orMat);
    // 转为3通道
    if(orMat.channels()==4){
        cv::cvtColor(orMat, rsMat, CV_BGRA2BGR);
    }else if(orMat.channels()==3){
        orMat.copyTo(rsMat);
    }else if(orMat.channels()==1){
        cv::cvtColor(orMat, rsMat, CV_GRAY2BGR);
    }else{
        orMat.copyTo(rsMat);
    }
    
    orMat.release();
    
    return rsMat;
    
}

@end
