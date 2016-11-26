//
//  TJ_PosterView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/24.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_PosterView.h"

@implementation TJ_PosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


- (CGFloat)tj_scale
{
    if (_tj_scale < 0.00001) {
        _tj_scale = 1.0;
    }
    return _tj_scale;
}



- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TJ_PosterTapGestureNotification" object:self];
}


@end
