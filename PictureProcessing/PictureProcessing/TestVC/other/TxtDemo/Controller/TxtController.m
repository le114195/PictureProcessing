//
//  TxtController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TxtController.h"
#import "GravityTxtView.h"
#import "TxtDemo2View.h"

@interface TxtController ()

@end

@implementation TxtController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demo2];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)demo1
{
    GravityTxtView *gravityView = [[GravityTxtView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gravityView];
}


- (void)demo2
{
    TxtDemo2View *demo2 = [[TxtDemo2View alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:demo2];
}



@end
