//
//  TJ_PictureBaseVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_PictureBaseVC.h"

@interface TJ_PictureBaseVC ()

@end

@implementation TJ_PictureBaseVC


- (instancetype)initWithImg:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.srcImg = image;
        if (image) {
            self.srcImgView.image = image;
            self.srcImgView.frame = [self resetImageViewFrameWithImage:image top:64 bottom:0];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)srcImgView
{
    if (!_srcImgView) {
        _srcImgView = [[UIImageView alloc] init];
        [self.view addSubview:_srcImgView];
    }
    return _srcImgView;
}





- (CGRect)resetImageViewFrameWithImage:(UIImage *)image top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right
{
    CGRect      newRect;
    if (!image) {
        newRect = CGRectMake(left, (Screen_Height - Screen_Width) / 2, Screen_Width, Screen_Width - (left + right));
    }else {
        
        CGFloat screen_height = Screen_Height - (top + bottom);
        CGFloat screen_width = Screen_Width - (left + right);
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat imageRate = imageWidth / imageHeight;
        
        if (imageRate >= screen_width / screen_height) {
            imageHeight = imageHeight * screen_width / imageWidth;
            imageWidth = screen_width;
        }else {
            imageWidth = imageWidth * screen_height / imageHeight;
            imageHeight = screen_height;
        }
        newRect = CGRectMake((Screen_Width - imageWidth) / 2, top + (Screen_Height - imageHeight - (top + bottom)) / 2, imageWidth, imageHeight);
    }
    return newRect;
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
