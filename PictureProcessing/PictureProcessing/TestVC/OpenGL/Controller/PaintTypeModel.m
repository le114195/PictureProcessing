//
//  PaintTypeModel.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "PaintTypeModel.h"

@implementation PaintTypeModel


+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    PaintTypeModel *model = [[PaintTypeModel alloc] init];
    
    model.name = [dict valueForKey:@"name"];
    model.imgName = [dict valueForKey:@"imgName"];
    
    return model;
}




@end
