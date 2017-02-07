//
//  OpenGL3DBaseController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenGL3DBaseController.h"
#import "TJ3DView.h"

@interface OpenGL3DBaseController ()

@end

@implementation OpenGL3DBaseController


+ (instancetype)openglesVCWithIndex:(NSInteger)index
{
    OpenGL3DBaseController *openglesVC = [[OpenGL3DBaseController alloc] init];
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
            [self openglFor3D];
            break;
        default:
            break;
    }
}

/** 3D */
- (void)openglFor3D
{
    TJ3DView *tj_3DView = [[TJ3DView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tj_3DView];
}



@end
