//
//  TJMoreLayerController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJMoreLayerController.h"

@interface TJMoreLayerController ()

@property (nonatomic, strong) NSMutableArray            *ImgViewArrM;

@property (nonatomic, strong) UIImageView               *testImgView;

@property (nonatomic, assign) CGFloat                   angle;

@end

@implementation TJMoreLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.ImgViewArrM = [NSMutableArray array];
    
    self.testImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 70, 100)];
    [self.view addSubview:_testImgView];
    self.testImgView.backgroundColor = [UIColor redColor];
    
    
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI * 0.3);
    
    self.testImgView.transform = transform;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
//    self.angle += 0.1;
//    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI * self.angle);
//    
//    self.testImgView.transform = transform;
    
    
    self.testImgView.center = CGPointMake(200, 250);
    
    NSLog(@"frame = %@", NSStringFromCGSize(self.testImgView.frame.size));
    NSLog(@"bounds = %@", NSStringFromCGSize(self.testImgView.bounds.size));
    
    
}





@end
