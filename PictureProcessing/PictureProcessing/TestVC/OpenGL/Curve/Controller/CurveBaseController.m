//
//  CurveBaseController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "CurveBaseController.h"
#import "TJOpenglesCurve.h"
#import "TJOpenglCurveEye.h"
#import "TJOpenglesCurveEyebrow.h"

@interface CurveBaseController ()

@end

@implementation CurveBaseController


+ (instancetype)openglesVCWithIndex:(NSInteger)index
{
    CurveBaseController *openglesVC = [[CurveBaseController alloc] init];
    [openglesVC demoWithIndex:index];
    return openglesVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)demoWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self demo7];
            break;
        case 1:
            [self curveEye];
            break;
        case 2:
            [self eyebrow];
            break;
        default:
            break;
    }
}

- (void)demo7
{
    //    UIImage *image = [UIImage imageNamed:@"imageTest002.png"];
    UIImage *image = [UIImage imageNamed:@"sj_20160705_1.JPG"];
    
    TJOpenglesCurve *curve = [[TJOpenglesCurve alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curve];
}


- (void)curveEye
{
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    UIImage *image = [UIImage imageNamed:@"IMG_0992.JPG"];
    TJOpenglCurveEye *curveEye = [[TJOpenglCurveEye alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curveEye];
    
}



//TJOpenglesCurveEyebrow
- (void)eyebrow
{
    
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    //sj_20160705_14.JPG
    //sj_20160705_26.JPG
    UIImage *image = [UIImage imageNamed:@"IMG_0991.JPG"];
    TJOpenglesCurveEyebrow *curveEyebrow = [[TJOpenglesCurveEyebrow alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curveEyebrow];
}






@end
