//
//  TJ_CacheController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/22.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJ_CacheController.h"

@interface TJ_CacheController ()


@property (nonatomic, strong) NSCache           *tj_cache;


@end

@implementation TJ_CacheController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *imageName1 = @"1234567dfgr";
    NSString *imageName2 = @"dfe34tr5erge";
    
    self.tj_cache = [[NSCache alloc] init];
    
    UIImage *image1 = [UIImage imageNamed:@"sj_20160705_1.JPG"];
    UIImage *image2 = [UIImage imageNamed:@"sj_20160705_10.JPG"];
    
    [self.tj_cache setObject:image1 forKey:imageName1];
    [self.tj_cache setObject:image2 forKey:imageName2];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *imageName1 = @"1234567dfgr";
    NSString *imageName2 = @"dfe34tr5erge";
    
    
    UIImage *image11 = [self.tj_cache objectForKey:imageName1];
    UIImage *image12 = [self.tj_cache objectForKey:imageName2];
    
    
    NSLog(@"%@", NSStringFromCGSize(image11.size));
    NSLog(@"%@", NSStringFromCGSize(image12.size));
}



@end
