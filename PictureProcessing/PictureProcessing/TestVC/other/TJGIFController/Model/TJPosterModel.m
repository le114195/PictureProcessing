//
//  TJPosterModel.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJPosterModel.h"
#import "TJ_PointConver.h"

@implementation TJPosterModel


+ (NSArray *)modelWithDict:(NSDictionary *)dict
                   faceImg:(UIImage *)faceImg
                 faceWidth:(CGFloat)faceWidth
                    point8:(CGPoint)point8
                 backWidth:(CGFloat)backWidth
                backHeight:(CGFloat)backHeight
{
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSArray *result = [dict valueForKey:@"result"];
    for (NSDictionary *dataDict in result) {
        
        TJPosterModel *model = [[TJPosterModel alloc] init];
        
        model.title = [dataDict valueForKey:@"title"];
        
        NSString *nodeName = [dataDict valueForKey:@"nodeName"];
        model.nodeName = nodeName;
        
        model.ImgType = [[dataDict valueForKey:@"imageType"] intValue];
        
        
        if ([nodeName isEqualToString:@"TJFaceLayer"]) {
            model.tj_image = faceImg;
        }else {
            if (model.ImgType) {
                model.tj_image = [UIImage imageNamed:[NSString stringWithFormat:@"rgba%@.png", model.title]];
            }else {
                model.tj_image = [UIImage imageNamed:[NSString stringWithFormat:@"rgba%@.jpg", model.title]];
            }
        }
        
        model.tj_angle = [[dataDict valueForKey:@"angle"] floatValue];
        model.tj_scale = [[dataDict valueForKey:@"scale"] floatValue];
        
        CGFloat locationX = [[dataDict valueForKey:@"locationX"] floatValue];
        CGFloat locationY = [[dataDict valueForKey:@"locationY"] floatValue];
        model.location = CGPointMake(locationX, locationY);
        
        //TODO:lejun
        if ([nodeName isEqualToString:@"TJFaceLayer"]) {
            
            model.referenceObject = 1;
            
            model.faceWidth = [[dataDict valueForKey:@"faceWidth"] floatValue];
            model.tj_scale = model.faceWidth / faceWidth;
            model.tj_size = faceImg.size;
            
            model.tj_center = CGPointMake(0, 0);
            
            //缩放和旋转后的定位点
            CGPoint newPoint8 = [TJ_PointConver tj_conver:point8 scale:model.tj_scale angle:model.tj_angle];
            CGPoint offset = CGPointMake((newPoint8.x - model.location.x), (newPoint8.y - model.location.y));
            
            model.tj_center = CGPointMake(-offset.x, - offset.y);
            
        }else {
            model.tj_size = CGSizeMake([[dataDict valueForKey:@"width"] floatValue], [[dataDict valueForKey:@"height"] floatValue]);
            model.tj_center = CGPointMake([[dataDict valueForKey:@"centerX"] floatValue], [[dataDict valueForKey:@"centerY"] floatValue]);
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
