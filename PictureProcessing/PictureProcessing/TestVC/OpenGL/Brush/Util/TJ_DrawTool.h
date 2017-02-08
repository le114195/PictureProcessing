//
//  TJ_DrawTool.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DrawCompletionBlock)(NSArray *array);


@interface TJ_DrawTool : NSObject

/** 根据移动的轨迹返回一组等距离的点 */
+ (void)constDisDraw:(CGPoint)location dis:(double)dis isStartMove:(BOOL)isStartMove completion:(DrawCompletionBlock)completion;


@end
