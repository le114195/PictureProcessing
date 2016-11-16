//
//  TJ_ImgView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/14.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_ImgView.h"

@implementation TJ_ImgView



- (CGFloat)tj_scale
{
    return [(NSNumber *)[self valueForKeyPath:@"layer.transform.scale"] floatValue];
}

- (CGFloat)tj_angle
{
    return [(NSNumber *)[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
}


@end
