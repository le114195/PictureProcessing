//
//  OpencvTestVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpencvTestVC.h"
#import "CategoryHeader.h"
#import "TJPixel.hpp"
#import "GrammarTest.hpp"


@interface OpencvTestVC ()


@end

@implementation OpencvTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.srcImageView.backgroundColor = [UIColor redColor];
    
    /*
    
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *faces = [faceDetector featuresInImage:image];
    
    
     */
    
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
    
//    [self scaleTest];
    
    
        [self pixelTest];
    
    //    [self edgeTest];
    
    
//    [self blendingTest];
    
    [self grammarTest];
    
}




/** 图片放缩 */
- (void)scaleTest {
    TJScale *scale = new TJScale();
    self.srcImageView.image = MatToUIImage(scale->resize_demo([self.imageName UTF8String], 0.5));
    
    
    Mat mat;
    UIImageToMat(self.srcImageView.image, mat);
    
    printf("%d", mat.channels());
    
    delete scale;
}


/** 图片像素操作 */
- (void)pixelTest {
    TJPixel *pixel = new TJPixel();
    
//    
//    float imgWidth = Screen_Width * 3;
//    float imgHeight = Screen_Height * 3;
//    
//    Mat srcMat = Mat::zeros(cv::Size(imgWidth, imgHeight), CV_8UC4);
//    pixel->drawCircle(srcMat, cv::Point(300, 300), 100);
//    
//    self.srcImageView.image = MatToUIImage(srcMat);
//    
//    Mat mat;
//    UIImageToMat(self.srcImageView.image, mat);
//    
//    printf("%d", mat.channels());
    
    
    NSString *imgPath = PictureHeader(@"sj_20160705_10.JPG");
    
    UIImage *imagePng = [UIImage imageNamed:@"tone_01_goldblue"];
    
    Mat srcMat = imread([imgPath UTF8String]);
    Mat mapMat;
    UIImageToMat(imagePng, mapMat);
    
    printf("%d\n", mapMat.channels());
    
    pixel->drawTest2(srcMat, mapMat);
    
    
    UIImage *image = MatToUIImage(srcMat);
    
    self.srcImageView.image = image;
    
    delete pixel;
}


/** 边缘检测 */
- (void)edgeTest {
    TJEdge *edge = new TJEdge();
    self.srcImageView.image = MatToUIImage(edge->canny_demo([self.imageName UTF8String]));
    delete edge;
}



/** 混合 */
- (void)blendingTest {
    
    TJBlend *blend = new TJBlend();
    
    
    self.srcImageView.image = MatToUIImage(blend->linearBlending1([self.imageName UTF8String], [self.imgName2 UTF8String]));
    
    delete blend;
}


#pragma mark - c++语法测试

- (void)grammarTest
{
//    [self virtual_test];
//    [self threadTest];
    
    
    GrammmarDemo *grammar = new GrammmarDemo();
    
    grammar->vecTest(10);
    delete grammar;
    
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
