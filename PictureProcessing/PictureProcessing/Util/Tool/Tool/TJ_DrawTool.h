//
//  TJ_DrawTool.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DrawCompletionBlock)(CGPoint point);


@interface TJ_DrawTool : NSObject


+ (void)constDisDraw:(CGPoint)location radius:(double)radius dis:(double)dis isStartMove:(BOOL)isStartMove completion:(DrawCompletionBlock)completion;


@end
