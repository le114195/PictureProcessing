//
//  GPUVideoCameraController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/1.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "GPUVideoCameraController.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImage.h"
#import "Masonry.h"
#import "TJ_GPUBeautifyFilter.h"
#import "UIImage+TJ.h"
#import "FaceDetectAPI.h"

@interface GPUVideoCameraController ()<GPUImageVideoCameraDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIView                    *cameraView;

@property (nonatomic, strong) UIImageView               *coverImgView;

@property (nonatomic, strong) GPUImageVideoCamera       *videoCamera;
@property (nonatomic, strong) GPUImageView              *filterView;
@property (nonatomic, strong) UIButton                  *beautifyButton;

//相片输出
@property (nonatomic)AVCaptureStillImageOutput          *ImageOutPut;


@property (strong, nonatomic) dispatch_queue_t          captureQueue;
    
@property (nonatomic, strong) TJ_GPUBeautifyFilter      *beautifyFilter;


@property (nonatomic, strong) UIImage                   *originImg;
@property (nonatomic, strong) UIImage                   *renderImg;


@property (nonatomic, strong)UIButton                   *PhotoButton;
@property (nonatomic, strong)UIButton                   *flashButton;

@property (nonatomic, assign)BOOL                       isflashOn;


@property (nonatomic, weak) UIView                      *redView;


@property (nonatomic, strong) UIImageView               *showImgView;


@property (nonatomic, strong) FaceDetectAPI             *detectAPI;

@end

@implementation GPUVideoCameraController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
//    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake((Screen_Width - 240)*0.5, 64, 240, 320)];
    self.cameraView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.cameraView.center = self.view.center;
    self.cameraView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cameraView];
    
    
    self.captureQueue = dispatch_queue_create("com.kimsungwhee.mosaiccamera.videoqueue", NULL);
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];;
    self.videoCamera.delegate = self;
    
    
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.cameraView.bounds];
    
    [self.cameraView addSubview:self.filterView];
    
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    
    [self beautify];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    if ([self.videoCamera.captureSession canAddOutput:self.ImageOutPut]) {
        [self.videoCamera.captureSession addOutput:self.ImageOutPut];
    }
    
    
    //人脸检测
    AVCaptureMetadataOutput* metaDataOutput =[[AVCaptureMetadataOutput alloc] init];
    if ([self.videoCamera.captureSession canAddOutput:metaDataOutput]) {
        [self.videoCamera.captureSession addOutput:metaDataOutput];
        
        //_faceUICache =[NSMutableDictionary dictionary];
        NSArray* supportTypes =metaDataOutput.availableMetadataObjectTypes;
        
        //NSLog(@"supports:%@",supportTypes);
        if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
            [metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
            [metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
        }
    }
    
    
//    //遮罩图517 × 600
//    self.coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 517 * 0.7, 600 * 0.7)];
//    self.coverImgView.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
//    [self.view addSubview:self.coverImgView];
//    self.coverImgView.image = [UIImage imageNamed:@"coverImg"];
    
    
    [self customUI];
    
}


#pragma mark - 子控制器

- (void)customUI {
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(Screen_Width*1/2.0-30, Screen_Height-100, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph"] forState: UIControlStateNormal];
    [_PhotoButton setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(Screen_Width*3/4.0-60, Screen_Height-100, 60, 60);
    [rightButton setTitle:@"切换" forState:UIControlStateNormal];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(Screen_Width*1/4.0-30, Screen_Height-100, 80, 60);
    [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashButton];
    
    
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.view addSubview:redView];
    self.redView = redView;
    
    redView.layer.borderColor = [UIColor redColor].CGColor;
    redView.layer.borderWidth = 2.0;
    
    redView.backgroundColor = [UIColor clearColor];
}




- (void)beautify {
    [self.videoCamera removeAllTargets];

    self.beautifyFilter = [[TJ_GPUBeautifyFilter alloc] init];
    
    [self.videoCamera addTarget:self.beautifyFilter];
    [self.beautifyFilter addTarget:self.filterView];
}






- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    _videoCamera.outputImageOrientation = orient;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // Support all orientations.
}


#pragma mark - set/get

- (UIImageView *)showImgView
{
    if (!_showImgView) {
        _showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 720 * 0.2, 1280 * 0.2)];
        [self.view addSubview:_showImgView];
    }
    return _showImgView;
}


- (FaceDetectAPI *)detectAPI
{
    if (!_detectAPI) {
        _detectAPI = [[FaceDetectAPI alloc] init];
    }
    return _detectAPI;
}



#pragma mark - 点击事件




/** 反转摄像头 */
- (void)changeCamera {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    if (self.videoCamera.frontFacingCameraPresent){
        animation.subtype = kCATransitionFromLeft;
    }
    else {
        animation.subtype = kCATransitionFromRight;
    }
    [self.filterView.layer addAnimation:animation forKey:nil];
    
    [self.videoCamera rotateCamera];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

}


/** 获取图片 */
- (void)shutterCamera
{
    [self outputImg:^(UIImage *outImg) {
        UIImage *image = [outImg fixOrientation];
        self.originImg = image;
        self.renderImg = [self.beautifyFilter imageByFilteringImage:self.originImg];
    }];
    
}


/** 输出图片 */
- (void)outputImg:(void(^)(UIImage * outImg))completion
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        if (completion) {
            completion(image);
        }
    }];
}




- (void)FlashOn {
    
    if ([self.videoCamera.inputCamera lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([self.videoCamera.inputCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.videoCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([self.videoCamera.inputCamera isFlashModeSupported:AVCaptureFlashModeOn]) {
                [self.videoCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }
        
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
    
}



#pragma mark - GPUImageVideoCameraDelegate代理方法
/** 用于输出图像 */
//GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count != 0)
    {
        AVMetadataFaceObject *ddd = [metadataObjects firstObject];

        CGRect newRect = ddd.bounds;
        
        newRect.origin.x = self.view.bounds.size.width * ddd.bounds.origin.y;
        newRect.origin.y = self.view.bounds.size.height * ddd.bounds.origin.x;
        
        newRect.size.height = self.view.bounds.size.width * ddd.bounds.size.height;
        newRect.size.width = self.view.bounds.size.height * ddd.bounds.size.width;
        
        self.redView.frame = newRect;
        
        //在这里执行检测到人脸后要执行的代码
        /*人脸数据存在metadataObjects这个数组里，数组中每一个元素对应一个metadataObject对象，该对象的各种属性对应人脸各种信息，具体可以查看API*/
    }
}



@end
