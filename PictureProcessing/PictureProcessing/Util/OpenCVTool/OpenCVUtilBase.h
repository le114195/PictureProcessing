//
//  OpenCVUtilBase.h
//  OpencvTest
//
//  Created by 勒俊 on 16/7/31.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>

using namespace cv;


@interface OpenCVUtilBase : NSObject


UIImage *imageWithMat(cv::Mat &srcMat);

+ (const char *)getImageWithImageName:(NSString *)imageName;




@end
