//
//  TJPosterModel.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJPosterModel.h"

@implementation TJPosterModel


+ (NSArray *)modelWithDict:(NSDictionary *)dict
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    
    NSArray *result = [dict valueForKey:@"result"];
    for (NSDictionary *dataDict in result) {
        
        TJPosterModel *model = [[TJPosterModel alloc] init];
        
        model.title = [dataDict valueForKey:@"title"];
        
        NSString *nodeName = [dataDict valueForKey:@"nodeName"];
        model.nodeName = nodeName;
        
        if ([nodeName isEqualToString:@"TJBackgroundLayer"]) {
            
            CGFloat locationX = [[dataDict valueForKey:@"locationX"] floatValue];
            CGFloat locationY = [[dataDict valueForKey:@"locationY"] floatValue];
            
            model.location = CGPointMake(locationX, locationY);
            
        }else {
            
            if ([nodeName isEqualToString:@"TJFaceLayer"]) {
                model.faceWidth = [[dataDict valueForKey:@"faceWidth"] floatValue];
            }
            
            model.tj_angle = [[dataDict valueForKey:@"angle"] floatValue];
            model.tj_scale = [[dataDict valueForKey:@"scale"] floatValue];
        }
        
        [arrM addObject:model];
    }
    
    return arrM;
}




- (CGFloat)tj_scale
{
    if (_tj_scale < 0.0001) {
        _tj_scale = 1.0;
    }
    return _tj_scale;
}




@end
