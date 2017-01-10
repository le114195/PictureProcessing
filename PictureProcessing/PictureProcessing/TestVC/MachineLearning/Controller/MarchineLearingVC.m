//
//  MarchineLearingVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/1/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "MarchineLearingVC.h"
#import "OpencvSVM.h"


@interface MarchineLearingVC ()

@end

@implementation MarchineLearingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [OpencvSVM ml_svm];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
