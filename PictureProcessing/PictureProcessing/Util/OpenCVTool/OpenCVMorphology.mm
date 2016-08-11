//
//  OpenCVMorphology.m
//  OpencvTest
//
//  Created by 勒俊 on 16/7/31.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpenCVMorphology.h"






@implementation OpenCVMorphology





/** 膨胀：求局部最大值 */
+ (UIImage *)dilateWithImageName:(NSString *)imageName size:(int)size
{
    Mat srcImage = imread([self getImageWithImageName:imageName]);
    Mat dstImage = Mat::zeros(srcImage.size(), srcImage.type());
    Mat element = getStructuringElement(MORPH_RECT, cv::Size(size, size));
    
    dilate(srcImage, dstImage, element);
    
    return imageWithMat(dstImage);
}



/** 腐蚀：求局部最小值 */
+ (UIImage *)erodeWithImageName:(NSString *)imageName size:(int)size
{
    Mat srcImage = imread([self getImageWithImageName:imageName]);
    Mat dstImage = Mat::zeros(srcImage.size(), srcImage.type());
    Mat element = getStructuringElement(MORPH_RECT, cv::Size(size, size));
    erode(srcImage, dstImage, element);
    
    return imageWithMat(dstImage);
}






@end
