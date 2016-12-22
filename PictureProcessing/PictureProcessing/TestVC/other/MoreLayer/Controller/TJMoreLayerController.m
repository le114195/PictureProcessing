//
//  TJMoreLayerController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJMoreLayerController.h"
#import "UIImage+TJ.h"
#import "TJ_PosterView.h"
#import "TJ_PosterContainerView.h"


@interface TJMoreLayerController ()

@property (nonatomic, strong) NSMutableArray                *ImgViewArrM;

@property (nonatomic, weak) TJ_PosterContainerView           *containtView;



@end

@implementation TJMoreLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self containtViewConfigure];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)containtViewConfigure
{
    TJ_PosterContainerView *containtView = [[TJ_PosterContainerView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
    [containtView setCenter:self.view.center];
    [self.view addSubview:containtView];
    self.containtView = containtView;
    
    TJ_PosterView *testImgView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 64, 325, 183)];
    [containtView addSubview:testImgView];
    
    testImgView.layer.borderWidth = 1.0;
    testImgView.layer.borderColor = [UIColor blueColor].CGColor;
    
    testImgView.backgroundColor = [UIColor redColor];
    
    
    
    TJ_PosterView *greenView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [testImgView addSubview:greenView];
    greenView.backgroundColor = [UIColor greenColor];
    
}


#pragma mark - 手势



@end
