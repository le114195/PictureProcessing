//
//  OpenCVUtilBase.m
//  OpencvTest
//
//  Created by 勒俊 on 16/7/31.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpenCVUtilBase.h"

@implementation OpenCVUtilBase

/** Mat转UIImage */
UIImage *imageWithMat(cv::Mat &srcMat)
{
    cvtColor(srcMat, srcMat, CV_BGR2RGB);
    return MatToUIImage(srcMat);
}

+ (const char *)getImageWithImageName:(NSString *)imageName
{
    return [PictureHeader(imageName) UTF8String];
}






@end
