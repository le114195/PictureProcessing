//
//  TJ_BlurController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/2.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_BlurController.h"
#import "TJ_BilateralTest.h"
#import "GPUImage.h"

@interface TJ_BlurController ()

@end

@implementation TJ_BlurController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bilateralTest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)bilateralTest
{
    
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    //sj_20160705_14.JPG
    //sj_20160705_26.JPG
    
    
    
    
    UIImage *image = [UIImage imageNamed:@"bea1.jpg"];
    
    TJ_BilateralTest *curveEyebrow = [[TJ_BilateralTest alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curveEyebrow];
}





@end
