//
//  TJOpenglCurveVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglCurveVC.h"
#import "TJOpenglesCurve.h"

@interface TJOpenglCurveVC ()

@end

@implementation TJOpenglCurveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo7];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)demo7
{
//    UIImage *image = [UIImage imageNamed:@"imageTest002.png"];
        UIImage *image = [UIImage imageNamed:@"sj_20160705_19.JPG"];
    
    TJOpenglesCurve *curve = [[TJOpenglesCurve alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:curve];
}



@end
