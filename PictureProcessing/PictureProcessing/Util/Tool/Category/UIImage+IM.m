//
//  UIImage+IM.m
//  TJExpression
//
//  Created by 勒俊 on 2016/12/30.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "UIImage+IM.h"

@implementation UIImage (IM)


- (void) drawAtCenter:(CGPoint) center Alpha:(CGFloat) alpha {
    CGPoint point = CGPointMake(center.x - self.size.width / 2, center.y - self.size.height / 2);
    [self drawAtPoint:point blendMode:kCGBlendModeNormal alpha:alpha];
}

- (void)drawAtCenter:(CGPoint)center Alpha:(CGFloat) alpha withTranslation:(CGPoint)translation radian:(CGFloat)radian scale:(CGFloat)scale {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, center.x + translation.x, center.y + translation.y);
    CGContextScaleCTM(context, scale, scale);
    CGContextRotateCTM(context, radian);
    [self drawAtCenter:CGPointZero Alpha:alpha];
    
    CGContextRestoreGState(context);
}

@end
