//
//  UIImage+TJ.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "UIImage+TJ.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <vector>

@implementation UIImage (TJ)


- (void)saveImageWithImgName:(NSString *)imgName imageType:(int)imageType
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = nil;
    if (imageType) {
        imageData = UIImagePNGRepresentation(self);
    }else {
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }
    [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", ToolDirectory, imgName] contents:imageData attributes:nil];
    
}


- (UIImage *)rotate
{
    cv::Mat src, dst;
    UIImageToMat(self, src, 1);
    
    dst = cv::Mat::zeros(src.cols, src.rows, src.type());
    
    switch (src.channels()) {
        case 1:{
            
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<uchar>(i, j) = src.at<uchar>(j, i);
                    
                }
            }
            break;
        }
        case 3:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec3b>(i, j)[0] = src.at<cv::Vec3b>(j, i)[0];
                    dst.at<cv::Vec3b>(i, j)[1] = src.at<cv::Vec3b>(j, i)[1];
                    dst.at<cv::Vec3b>(i, j)[2] = src.at<cv::Vec3b>(j, i)[2];
                }
            }
            
            break;
        }
        case 4:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec4b>(i, src.rows - j - 1)[0] = src.at<cv::Vec4b>(j, i)[0];
                    dst.at<cv::Vec4b>(i, src.rows - j - 1)[1] = src.at<cv::Vec4b>(j, i)[1];
                    dst.at<cv::Vec4b>(i, src.rows - j - 1)[2] = src.at<cv::Vec4b>(j, i)[2];
                    dst.at<cv::Vec4b>(i, src.rows - j - 1)[3] = src.at<cv::Vec4b>(j, i)[3];
                }
            }
            break;
        }
        default:
            break;
    }

    return MatToUIImage(dst);
}



@end
