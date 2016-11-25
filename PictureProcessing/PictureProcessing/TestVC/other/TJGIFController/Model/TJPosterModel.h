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
@property (nonatomic, assign) CGFloat           width;


@property (nonatomic, copy) NSString            *title;

@property (nonatomic, assign) CGFloat           angle;

@property (nonatomic, assign) CGFloat           scale;


@end
