//
//  FaceDetectAPI.h
//  faceDetection
//
//  Created by 崔海港 on 2016/11/1.
//  Copyright © 2016年 Geniteam. All rights reserved.

//  ios人脸检测的接口封装

#import <Foundation/Foundation.h>

@interface FaceDetectAPI : NSObject

/**
 检测的人脸对象（脸，眼睛，嘴巴）的位置结构体
*/
struct ObjectRect{
    int x;
    int y;
    int width;
    int height;
};

/**
 人脸区域检测函数

 @param inputImage 要检测的图像
 @return 人脸区域的位置Rect,未检测到Rect为0
 */
-(struct ObjectRect)dectetFacePosition:(UIImage *)inputImage;

/**
 左眼区域检测函数
 
 @param inputImage 要检测的图像
 @return 左眼区域的位置Rect,未检测到Rect为0
 */
-(struct ObjectRect)dectetLeftEyePosition:(UIImage *)inputImage;

/**
 右眼区域检测函数
 
 @param inputImage 要检测的图像
 @return 右眼区域的位置Rect,未检测到Rect为0
 */
-(struct ObjectRect)dectetRightEyePosition:(UIImage *)inputImage;

/**
 嘴巴区域检测函数
 
 @param inputImage 要检测的图像
 @return 嘴巴区域的位置Rect,未检测到Rect为0
 */
-(struct ObjectRect)dectetMouthPosition:(UIImage *)inputImage;

@end
