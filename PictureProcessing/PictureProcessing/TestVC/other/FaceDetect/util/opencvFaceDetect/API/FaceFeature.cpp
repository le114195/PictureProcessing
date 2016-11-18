//
//  FaceFeature.cpp
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "FaceFeature.hpp"


FaceFeature::FaceFeature(double scale_factor, int min_neighbours, int flags, CvSize min_size) {
    
    haarScaleFactor = scale_factor;
    haarMinNeighbours = min_neighbours;
    haarFlags = flags;
    minFeatureSize = min_size;
}
