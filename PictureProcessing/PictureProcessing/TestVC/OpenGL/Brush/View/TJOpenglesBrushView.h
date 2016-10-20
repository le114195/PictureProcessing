//
//  TJOpenglesBrushView.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPoint : NSObject

@property (nonatomic , strong) NSNumber* mY;
@property (nonatomic , strong) NSNumber* mX;

@end


@interface TJOpenglesBrushView : UIView


@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;


- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
