//
//  TJOpenglCurveVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglCurveVC.h"
#import "TJOpenglesCurve.h"
#import "TJOpenglCurveEye.h"
#import "TJOpenglesCurveEyebrow.h"



@interface TJOpenglCurveVC ()

@end

@implementation TJOpenglCurveVC


+ (instancetype)curveWithType:(int)type
{
    TJOpenglCurveVC *curveVC = [[TJOpenglCurveVC alloc] init];
    
    switch (type) {
        case 0:{
            [curveVC demo7];
            break;
        }
        case 1:{
            [curveVC curveEye];
            break;
        }
        case 2:{
            [curveVC eyebrow];
            break;
        }
            
        default:
            break;
    }
    
    return curveVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
