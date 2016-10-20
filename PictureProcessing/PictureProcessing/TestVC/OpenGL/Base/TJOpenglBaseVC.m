//
//  TJOpenglBaseVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglBaseVC.h"

@interface TJOpenglBaseVC ()

@end

@implementation TJOpenglBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/** 设置editImageView的frame */
- (CGRect)resetImageViewFrameWithImage:(UIImage *)image top:(CGFloat)top bottom:(CGFloat)bottom {
    
    CGRect      newRect;
    if (!image) {
        newRect = CGRectMake(0, (Screen_Height - Screen_Width) / 2, Screen_Width, Screen_Width);
    }else {
        
        CGFloat screen_height = Screen_Height - (top + bottom);
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat imageRate = imageWidth / imageHeight;
        
        if (imageRate >= Screen_Width / screen_height) {
            imageHeight = imageHeight * Screen_Width / imageWidth;
            imageWidth = Screen_Width;
        }else {
            imageWidth = imageWidth * screen_height / imageHeight;
            imageHeight = screen_height;
        }
        newRect = CGRectMake((Screen_Width - imageWidth) / 2, top + (Screen_Height - imageHeight - (top + bottom)) / 2, imageWidth, imageHeight);
    }
    return newRect;
}



@end
