//
//  FaceDetectVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "FaceDetectVC.h"
#import "TJSSHTTPBase.h"
#import "TJURLSession.h"
#import "FaceDetectCPlusPlusAPI.hpp"


#import <opencv2/imgcodecs/ios.h>
#import <opencv2/opencv.hpp>

#import "TJ_PointConver.h"
#import "TJ_PosterContainerView.h"
#import "GDataXMLNode.h"
#import "FaceLandmarkInterface.h"



@interface FaceDetectVC ()

@property (nonatomic, weak) UIView          *face_rectV;
@property (nonatomic, assign) CGFloat       ImgRateW;
@property (nonatomic, assign) CGFloat       ImgRateH;


@property (nonatomic, weak) TJ_PosterContainerView           *containtView;

@end

@implementation FaceDetectVC


+ (instancetype)picture:(UIImage *)image
{
    FaceDetectVC *faceVC = [[FaceDetectVC alloc] initWithImg:image];
    return faceVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"constData_haha_hader"];
    
    NSArray *array = [FaceLandmarkInterface getLanmarkPointFromUIImage:image];
    
    
    UIImage *showImg = [self drawImgWithImage:image pointArr:array];
    
    
    NSLog(@"%@", NSStringFromCGSize(showImg.size));
    
}


- (UIImage *)drawImgWithImage:(UIImage *)image pointArr:(NSArray *)pointArr
{
    cv::Mat orMat;
    UIImageToMat(image, orMat);
    // 转为3通道
    cv::Mat rsMat;
    if(orMat.channels()==4){
        cv::cvtColor(orMat, rsMat, CV_BGRA2BGR);
    }else if(orMat.channels()==3){
        orMat.copyTo(rsMat);
    }else if(orMat.channels()==1){
        cv::cvtColor(orMat, rsMat, CV_GRAY2BGR);
    }else{
        orMat.copyTo(rsMat);
    }
    
    int sizePoint = (int)pointArr.count/2;
    for (int i = 0; i < sizePoint; i++) {
        int x = [pointArr[i] intValue];
        int y = [pointArr[i + sizePoint] intValue];
        
        std::stringstream ss;
        ss << i;
        cv::putText(rsMat, ss.str(), cv::Point(x, y), 0.5, 0.5, cv::Scalar(0, 0, 255));
        cv::circle(rsMat, cv::Point(x, y), 2, cv::Scalar(0, 0, 255), -1);
    }
    
    UIImage *resImage = MatToUIImage(rsMat);
    
    return resImage;
}



- (void)decodeXml
{
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"1479719953719c400010m400010.xml" ofType:nil];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *document =  [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    
    NSArray *array = [rootElement children];
    
    for (GDataXMLElement *element in array) {
        
        NSMutableDictionary *eleDict = [NSMutableDictionary dictionary];
        [eleDict setValue:[[element.attributes firstObject] stringValue] forKey:@"time"];
        
        NSMutableArray *dictArr = [NSMutableArray array];
        
        NSArray *eleArr = [element children];
    
        for (GDataXMLElement *imgEle in eleArr) {
            // 根据标签名判断
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            // 标签名
            tempDic[@"nodeName"] = [imgEle name];
            // 标签内容
            if([imgEle stringValue].length != 0){
                tempDic[@"nodeValue"] = [imgEle stringValue];
            }
            // 标签属性
            for (int i = 0; i < imgEle.attributes.count; i++) {
                NSString *key = [imgEle.attributes[i] name];
                NSString *value = [imgEle.attributes[i] stringValue];
                tempDic[key] = value;
            }
            [dictArr addObject:tempDic];
        }
        [eleDict setValue:dictArr forKey:@"result"];
        [arrM addObject:eleDict];
    }
    
    NSLog(@"%@", arrM);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








/** openCV人脸检测 */
- (void)openCVDetect
{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_7.JPG" ofType:nil];
    
    UIImage *image = [UIImage imageNamed:@"rgba1475982568575c1000007m10000071"];
    
    self.srcImgView.image = image;
    self.srcImgView.frame = [self resetImageViewFrameWithImage:image top:64 bottom:0];
    
    
    cv::Mat src;
    UIImageToMat(image, src, 1);
    
    NSString *bundlePathString = [[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"%@",@"/"];
    
    FaceDetectCPlusPlusAPI *detect = new FaceDetectCPlusPlusAPI(src, [bundlePathString cStringUsingEncoding:NSASCIIStringEncoding]);
    
    detect->findFace();
    detect->findMouth();
    
    UIImage *image00 = MatToUIImage(detect->displayImage);
    
    self.srcImgView.image = image00;
    
    float width = detect->faceRect.width;
    
    NSLog(@"%f", width);
    
    delete detect;
}



/** face++人脸检测 */
- (void)facePlusDetect
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:MG_LICENSE_KEY forKey:@"api_key"];
    [dict setValue:MG_LICENSE_SECRE forKey:@"api_secret"];
    [dict setValue:@1 forKey:@"return_landmark"];
    
    NSString *url = @"https://api.megvii.com/facepp/v3/detect";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_7.JPG" ofType:nil];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    self.srcImgView.image = image;
    self.srcImgView.frame = [self resetImageViewFrameWithImage:image top:64 bottom:0];
    
    self.ImgRateW = image.size.width / self.srcImgView.bounds.size.width;
    self.ImgRateH = image.size.height / self.srcImgView.bounds.size.height;
    
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    [data writeToFile:[NSString stringWithFormat:@"%@/%@", ToolDirectory, @"1234.jpg"] atomically:YES];
    
    path = [NSString stringWithFormat:@"%@/%@", ToolDirectory, @"1234.jpg"];
    
    UIView *face_rectV = [[UIView alloc] init];
    self.face_rectV = face_rectV;
    [self.srcImgView addSubview:face_rectV];
    self.face_rectV.backgroundColor = [UIColor redColor];
    
    
    [TJURLSession postWithUrl:url parameters:dict paths:@[path] fieldName:@"image_file" completion:^(id responseObject, int status) {
        
        NSLog(@"%@", responseObject);
        
        NSArray *array = [responseObject valueForKey:@"faces"];
        
        NSDictionary *face = [array firstObject];
        
        NSDictionary *face_rectangle = [face valueForKey:@"face_rectangle"];
        
        CGFloat height = [[face_rectangle valueForKey:@"height"] floatValue];
        CGFloat left = [[face_rectangle valueForKey:@"left"] floatValue];
        CGFloat top = [[face_rectangle valueForKey:@"top"] floatValue];
        CGFloat width = [[face_rectangle valueForKey:@"width"] floatValue];
        
        self.face_rectV.frame = CGRectMake(left / self.ImgRateW, top / self.ImgRateH, width / self.ImgRateW, height / self.ImgRateH);
        
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
}


@end
