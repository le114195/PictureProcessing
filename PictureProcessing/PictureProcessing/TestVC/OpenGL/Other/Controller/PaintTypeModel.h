//
//  PaintTypeModel.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaintTypeModel : NSObject

@property (nonatomic, copy) NSString            *name;
@property (nonatomic, copy) NSString            *imgName;


+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
