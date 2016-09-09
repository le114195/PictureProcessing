//
//  TJOpencvBase.hpp
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/3.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef TJOpencvBase_hpp
#define TJOpencvBase_hpp

#include <stdio.h>
#import <opencv2/opencv.hpp>
#import <vector>


using namespace cv;
using namespace std;

class TJOpenCVBase{
    
public:
    
    Mat showImage(const char *imageName);
    
    static void converBGR2RGB(Mat dstMat);
    
    
    
protected:
    
    Mat srcImage;
    Mat dstImage;
    
private:
    
    
    
    
};



#endif /* TJOpencvBase_hpp */
