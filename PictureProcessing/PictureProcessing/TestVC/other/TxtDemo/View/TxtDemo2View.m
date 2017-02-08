//
//  TxtDemo2View.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TxtDemo2View.h"
#import "UIView+TJ.h"
#import "UIImage+IM.h"


@implementation TxtDemo2View


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        CGFloat txtSize = 37.0;
        
        NSArray *array = @[@"哈", @"哈", @"哈", @"哈"];
        
        int i = 0;
        for (NSString *str in array) {
            
            UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + i * (txtSize + 5), 70, txtSize, txtSize)];
            [self.containerView addSubview:testLabel];
            
            testLabel.font = [UIFont systemFontOfSize:txtSize];
            testLabel.backgroundColor = [UIColor redColor];
            testLabel.text = str;
            
            [self.arrM addObject:testLabel];
            i++;
        }
        
        UIView *view = [self.arrM firstObject];
    
        UIImage *newImg = [view drawImage];
        
        [self drawLayerImgWithBGSize:self.containerView.bounds.size image:newImg];

        
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        int i = 0;
        for (UIView *view in self.arrM) {
            view.layer.transform = CATransform3DMakeScale(2.0, 2.0, 1);
            view.layer.transform = CATransform3DMakeTranslation(i * 20, 0, 0);
            i++;
        }
    }];
}

- (void)drawLayerImgWithBGSize:(CGSize)bgSize image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(bgSize, NO, 1.0);
    
    [image drawAtCenter:CGPointMake(bgSize.width * 0.5, bgSize.height * 0.5) Alpha:1.0 withTranslation:CGPointMake(0, 0) radian:0 scale:1.0];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}



@end
