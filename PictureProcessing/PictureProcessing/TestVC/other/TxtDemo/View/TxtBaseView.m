//
//  TxtBaseView.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TxtBaseView.h"

@implementation TxtBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.arrM = [NSMutableArray array];
        
        self.backgroundColor = [UIColor greenColor];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, Screen_Width, 200)];
        [self addSubview:containerView];
        containerView.backgroundColor = [UIColor whiteColor];
        self.containerView = containerView;
        containerView.layer.masksToBounds = YES;
        
    }
    return self;
}



@end
