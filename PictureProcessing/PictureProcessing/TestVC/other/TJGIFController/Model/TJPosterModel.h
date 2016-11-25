//
//  TJPosterModel.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJPosterModel : NSObject

/** 确定头的位置 */
@property (nonatomic, assign) CGPoint           location;


/** 脸的宽度 */
@property (nonatomic, assign) CGFloat           faceWidth;


@property (nonatomic, copy) NSString            *nodeName;


@property (nonatomic, copy) NSString            *title;


@property (nonatomic, assign) CGFloat           tj_angle;


@property (nonatomic, assign) CGFloat           tj_scale;





+ (NSArray *)modelWithDict:(NSDictionary *)dict;


@end
