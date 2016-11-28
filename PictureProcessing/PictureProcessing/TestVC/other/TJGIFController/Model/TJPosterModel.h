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


@property (nonatomic, assign) CGSize            tj_size;


@property (nonatomic, assign) CGPoint           tj_center;


/** 
 *  0：jpg
 *  1：png
 */
@property (nonatomic, assign) int               ImgType;

@property (nonatomic, strong) UIImage           *tj_image;



+ (NSArray *)modelWithDict:(NSDictionary *)dict faceImg:(UIImage *)faceImg point8:(CGPoint)point8 backWidth:(CGFloat)backWidth backHeight:(CGFloat)backHeight faceWidth:(CGFloat)faceWidth;


@end
