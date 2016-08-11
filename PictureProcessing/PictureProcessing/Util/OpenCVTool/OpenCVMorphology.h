//
//  OpenCVMorphology.h
//  OpencvTest
//
//  Created by 勒俊 on 16/7/31.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpenCVUtilBase.h"

@interface OpenCVMorphology : OpenCVUtilBase


+ (UIImage *)dilateWithImageName:(NSString *)imageName size:(int)size;


+ (UIImage *)erodeWithImageName:(NSString *)imageName size:(int)size;

@end
