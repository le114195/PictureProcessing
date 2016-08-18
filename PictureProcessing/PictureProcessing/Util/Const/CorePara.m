//
//  CorePara.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "CorePara.h"

@implementation CorePara



/** CIColorControls */
+ (NSDictionary *)colorControls
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputSaturation", @"defauleValue":@1, @"mini":@0, @"max":@2};
    NSDictionary *slider2 = @{@"name":@"inputContrast", @"defauleValue":@1, @"mini":@0.25, @"max":@4};
    NSArray *sliderValue = @[slider1, slider2];
    [parameters setValue:@"CIColorControls" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}


/** CIBoxBlur */
+ (NSDictionary *)boxBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputRadius", @"defauleValue":@10, @"mini":@1, @"max":@100};
    NSArray *sliderValue = @[slider1];
    [parameters setValue:@"CIBoxBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}



/** CIDiscBlur */
+ (NSDictionary *)discBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputRadius", @"defauleValue":@8, @"mini":@0, @"max":@100};
    NSArray *sliderValue = @[slider1];
    [parameters setValue:@"CIDiscBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}

/** CIGaussianBlur：高斯模糊 */
+ (NSDictionary *)gaussianBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputRadius", @"defauleValue":@10, @"mini":@0, @"max":@100};
    NSArray *sliderValue = @[slider1];
    [parameters setValue:@"CIGaussianBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}

/** CIMaskedVariableBlur */
+ (NSDictionary *)maskedVariableBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputRadius", @"defauleValue":@10, @"mini":@(0), @"max":@(100)};
    NSArray *sliderValue = @[slider1];
    [parameters setValue:@"CIMaskedVariableBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}


/** CIMedianFilter */
+ (NSDictionary *)medianFilter
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"CIMedianFilter" forKey:@"filterName"];
    return parameters;
}

/** CIMotionBlur */
+ (NSDictionary *)motionBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputRadius", @"defauleValue":@20, @"mini":@(0), @"max":@(60)};
    NSDictionary *slider2 = @{@"name":@"inputAngle", @"defauleValue":@0, @"mini":@(-3.14), @"max":@3.14};
    NSArray *sliderValue = @[slider1, slider2];
    [parameters setValue:@"CIMotionBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}

/** CINoiseReduction：官网说可以去掉脸上的麻点 */
+ (NSDictionary *)noiseReduction
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputNoiseLevel", @"defauleValue":@0.02, @"mini":@(0), @"max":@1};
    NSDictionary *slider2 = @{@"name":@"inputSharpness", @"defauleValue":@0.4, @"mini":@(0), @"max":@1};
    NSArray *sliderValue = @[slider1, slider2];
    [parameters setValue:@"CINoiseReduction" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}


/** CIZoomBlur */
+ (NSDictionary *)zoomBlur
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *slider1 = @{@"name":@"inputAmount", @"defauleValue":@20, @"mini":@(0), @"max":@30};
    NSArray *sliderValue = @[slider1];
    [parameters setValue:@"CIZoomBlur" forKey:@"filterName"];
    [parameters setValue:sliderValue forKey:@"sliderValue"];
    return parameters;
}






@end
