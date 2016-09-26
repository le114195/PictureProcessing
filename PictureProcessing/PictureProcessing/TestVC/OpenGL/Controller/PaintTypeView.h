//
//  PaintTypeView.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/26.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintTypeView : UIView


@property (nonatomic, strong) NSArray           *dataArray;

@property (nonatomic, copy) void(^didSelectBlock)(NSInteger index);


@end
