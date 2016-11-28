//
//  TJShowGIFController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/28.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJShowGIFController.h"

@interface TJShowGIFController ()

@property (nonatomic, strong) NSArray                    *ImgArray;

@end

@implementation TJShowGIFController


+ (instancetype)showWithImgArray:(NSArray *)ImgArray
{
    TJShowGIFController *showVC = [[TJShowGIFController alloc] init];
    
    showVC.ImgArray = ImgArray;
    
    return showVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self test];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)test
{
    //650*366
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
    [gifImageView setCenter:self.view.center];
    gifImageView.animationImages = self.ImgArray; //获取Gif图片列表
    gifImageView.animationDuration = 2.5;     //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 100;  //动画重复次数
    [gifImageView startAnimating];
    [self.view addSubview:gifImageView];
}






@end
