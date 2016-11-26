//
//  TJ_Cache.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/22.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_Cache.h"



@interface TJ_Cache ()


@end


@implementation TJ_Cache












#pragma mark - 单利模式

+ (instancetype)shareInstance
{
    static TJ_Cache * tj_cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tj_cache = [[super allocWithZone:NULL] init];
        
    });
    return tj_cache;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [TJ_Cache shareInstance];
    
}



@end
