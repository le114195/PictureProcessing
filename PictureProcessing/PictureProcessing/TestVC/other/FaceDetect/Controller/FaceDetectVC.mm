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




@interface FaceDetectVC ()


@property (nonatomic, weak) UIView          *face_rectV;

@property (nonatomic, assign) CGFloat       ImgRateW;
@property (nonatomic, assign) CGFloat       ImgRateH;



@end

@implementation FaceDetectVC


+ (instancetype)picture:(UIImage *)image
{
    FaceDetectVC *faceVC = [[FaceDetectVC alloc] initWithImg:image];
    return faceVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self openCVDetect];
    
    
//    [self faceTextByImage:self.srcImg];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** openCV人脸检测 */
- (void)openCVDetect
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sj_20160705_7.JPG" ofType:nil];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
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
