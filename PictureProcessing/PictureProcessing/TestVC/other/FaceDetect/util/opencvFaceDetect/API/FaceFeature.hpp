//
//  FaceFeature.hpp
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef FaceFeature_hpp
#define FaceFeature_hpp

#include <stdio.h>
#include <string>
#include <math.h>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>


class FaceFeature {
public:
    FaceFeature(double scale_factor,int min_neighbours,int flags,CvSize min_size);
    double haarScaleFactor;
    int haarMinNeighbours;
    int haarFlags;
    CvSize minFeatureSize;
};


#endif /* FaceFeature_hpp */
