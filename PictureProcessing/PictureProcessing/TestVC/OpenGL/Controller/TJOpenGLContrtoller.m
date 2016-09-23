//
//  TJOpenGLContrtoller.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenGLContrtoller.h"
#import "TJOpenglesDemo1.h"
#import "TJOpenglesBrushView.h"

@interface TJOpenGLContrtoller ()

@end

@implementation TJOpenGLContrtoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    TJOpenglesDemo1 *demo1 = [[TJOpenglesDemo1 alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64)];
    [self.view addSubview:demo1];
    
    
//    TJOpenglesBrushView *brushView = [[TJOpenglesBrushView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
//    [self.view addSubview:brushView];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
