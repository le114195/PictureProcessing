//
//  OpencvTest.m
//  OpenCVTest
//
//  Created by 勒俊 on 16/7/31.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpencvTest.h"

@implementation OpencvTest


+ (UIImage *)showImageWithImagePath:(NSString *)imagePath
{
    const char *path = [imagePath UTF8String];
    Mat srcMat = imread(path);
    return imageWithMat(srcMat);
}

+ (UIImage *)ROI_AddImage
{
    Mat srcImage = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    Mat logoImage = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    
    Mat imageROI = srcImage(cv::Rect(100, 100, logoImage.cols, logoImage.rows));
    
    Mat mask = imread([self getImageWithImageName:@"sj_20160705_17.JPG"], 0);
    
    logoImage.copyTo(imageROI, mask);
    return imageWithMat(srcImage);
}

+ (UIImage *)linearBlending
{
    double alphaValue = 0.8;
    double betaValue;
    
    Mat srcImage2, srcImage3, dstImage;
    
    srcImage2 = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    srcImage3 = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    
    if (!srcImage2.data) {
        NSLog(@"src2文件读取错误！！！");
        return nil;
    }
    if (!srcImage3.data) {
        NSLog(@"src3文件读取错误！！！");
        return nil;
    }
    
    betaValue = 1.0 - alphaValue;
    cv::addWeighted(srcImage2, alphaValue, srcImage3, betaValue, 0.0, dstImage);
    
    return imageWithMat(dstImage);
}

+ (UIImage *)on_ContrastAndBright:(NSString *)imagePath
{
    int g_ncValue = 80;
    int g_nbValue = 80;
    
    const char* imgPath = [imagePath UTF8String];
    Mat srcImage = imread(imgPath);
    Mat dstImage = Mat::zeros(srcImage.size(), srcImage.type());
    
    
    for (int y = 0; y < srcImage.rows; y++) {
        
        for (int x = 0; x < srcImage.cols; x++) {
            
            for (int c = 0; c < 3; c++) {
                
                dstImage.at<Vec3b>(y, x)[c] = saturate_cast<uchar>((g_ncValue * 0.01) * (srcImage.at<Vec3b>(y, x)[c]) + g_nbValue);
            }
        }
    }
    return imageWithMat(srcImage);
}

+ (UIImage *)gauuTest
{
    Mat srcImage, dstImage;
    
    srcImage = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    dstImage = srcImage.clone();
    
    GaussianBlur(srcImage, dstImage, cv::Size(5, 5), 0, 0);
    
    return imageWithMat(dstImage);
}


+ (UIImage *)boxFilterTest
{
    Mat srcImage, dstImage;
    
    srcImage = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    dstImage = srcImage.clone();
    
    boxFilter(srcImage, dstImage, -1, cv::Size(8, 8));
    
    return imageWithMat(dstImage);
}


+ (UIImage *)blurTest
{
    Mat srcImage, dstImage;
    
    srcImage = imread([self getImageWithImageName:@"sj_20160705_17.JPG"]);
    dstImage = srcImage.clone();
    
    
    blur(srcImage, dstImage, cv::Size(7, 7));
    
    return imageWithMat(dstImage);
}




@end
