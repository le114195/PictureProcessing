//
//  TJ_DrawTool.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TJ_DrawTool : NSObject

+ (CGPoint)newPointLastPoint:(CGPoint)lastLocation currentPoint:(CGPoint)location distance:(double)distance;

@end
