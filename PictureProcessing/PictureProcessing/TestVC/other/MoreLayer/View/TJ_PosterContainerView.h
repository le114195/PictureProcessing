//
//  TJ_PosterContaintView.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/24.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJ_PosterView;


@interface TJ_PosterContainerView : UIView

@property (nonatomic, weak) TJ_PosterView       *currentPoster;


@property (nonatomic, copy) void(^scaleBlock)(CGFloat scale);
@property (nonatomic, copy) void(^rotateBlock)(CGFloat angle);
@property (nonatomic, copy) void(^translationBlock)(CGPoint offset);




@end
