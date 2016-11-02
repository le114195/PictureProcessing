//
//  TJ_GPUBeautifyFilter.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/2.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "GPUImage.h"

@class GPUImageCombinationFilter1;

@interface TJ_GPUBeautifyFilter : GPUImageFilterGroup {
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCombinationFilter1 *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}




@end
