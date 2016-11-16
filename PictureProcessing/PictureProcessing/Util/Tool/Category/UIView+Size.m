//
//  UIView+Size.m
//  TJSocial
//
//  Created by 勒俊 on 16/4/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "UIView+Size.h"

@implementation UIView (Size)



- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}



- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}




- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}



- (CGFloat)heigth
{
    return self.frame.size.height;
}

- (void)setHeigth:(CGFloat)heigth
{
    CGRect rect = self.frame;
    rect.size.height = heigth;
    self.frame = rect;
}


- (CGFloat)maxX
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.maxX = maxX;
}


- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMaxY:(CGFloat)maxY
{
    self.maxY = maxY;
}




@end
