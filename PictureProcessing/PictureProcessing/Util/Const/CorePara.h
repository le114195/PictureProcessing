//
//  CorePara.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CorePara : NSObject


/** CIColorControls */
+ (NSDictionary *)colorControls;

/** CIBoxBlur */
+ (NSDictionary *)boxBlur;

/** CIDiscBlur */
+ (NSDictionary *)discBlur;


/** CIGaussianBlur：高斯模糊 */
+ (NSDictionary *)gaussianBlur;


/** CIMaskedVariableBlur */
+ (NSDictionary *)maskedVariableBlur;


/** CIMedianFilter */
+ (NSDictionary *)medianFilter;

/** CIMotionBlur */
+ (NSDictionary *)motionBlur;


/** CINoiseReduction */
+ (NSDictionary *)noiseReduction;

/** CIZoomBlur */
+ (NSDictionary *)zoomBlur;


@end
