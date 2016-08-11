//
//  OpencvTestVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpencvTestVC.h"


@interface OpencvTestVC ()


@end

@implementation OpencvTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self openCVTest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - OpenCVTest

- (void)openCVTest
{
    
    //    self.srcImageView.image = MatToUIImage(TJMorphology::close_demo([self.imageName UTF8String], 5));
    
    //    self.srcImageView.image = MatToUIImage(TJMorphology::open_demo([self.imageName UTF8String], 5));
    
    [self scaleTest];
    
    
    //    [self pixelTest];
    
    //    [self edgeTest];
    
    
}




/** 图片放缩 */
- (void)scaleTest {
    
    TJScale *scale = new TJScale();
    
    
    self.srcImageView.image = MatToUIImage(scale->ROI_demo([self.imageName UTF8String]));
    
    
    delete scale;
    
}


/** 图片像素操作 */
- (void)pixelTest {
    
    TJPixel *pixel = new TJPixel();
    
    
    self.srcImageView.image = MatToUIImage(pixel->cutImage([self.imageName UTF8String]));
    
    
    delete pixel;
}


/** 边缘检测 */
- (void)edgeTest {
    
    TJEdge *edge = new TJEdge();
    
    self.srcImageView.image = MatToUIImage(edge->canny_demo([self.imageName UTF8String]));
    
    delete edge;
}





#pragma mark - c++语法测试

- (void)grammarTest
{
    [self virtual_test];
    [self threadTest];
}

/** 静态函数、虚函数和纯虚函数测试 */
- (void)virtual_test
{
    GrammmarDemo *demo = new GrammmarDemo();
    GrammmarDemo::static_test();
    demo->virtual_test();
    demo->pure_virtual();
    delete demo;
}



/** c++多线程测试 */
- (void)threadTest
{
    TJPthread *thread = new TJPthread();
    thread->createThread(thred_func, NULL);
    
    delete thread;
}

void *thred_func(void *parameter)
{
    printf("hello 线程启动");
    return NULL;
}










@end
