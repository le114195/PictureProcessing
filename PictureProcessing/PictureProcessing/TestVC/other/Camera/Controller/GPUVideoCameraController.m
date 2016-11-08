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

@interface GPUVideoCameraController ()<GPUImageVideoCameraDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIView                    *cameraView;

@property (nonatomic, strong) UIImageView               *coverImgView;

@property (nonatomic, strong) GPUImageVideoCamera       *videoCamera;
@property (nonatomic, strong) GPUImageView              *filterView;
@property (nonatomic, strong) UIButton                  *beautifyButton;

//相片输出
@property (nonatomic)AVCaptureStillImageOutput          *ImageOutPut;

@property (strong, nonatomic) dispatch_queue_t          captureQueue;
@property (nonatomic, strong) NSArray                   *faceObjects;
    
@property (nonatomic, strong) TJ_GPUBeautifyFilter      *beautifyFilter;


@property (nonatomic, strong) UIImage                   *originImg;
@property (nonatomic, strong) UIImage                   *renderImg;


@property (nonatomic, strong)UIButton                   *PhotoButton;
@property (nonatomic, strong)UIButton                   *flashButton;

@property (nonatomic, assign)BOOL                       isflashOn;

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
    
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake((Screen_Width - 240)*0.5, 64, 240, 320)];
    self.cameraView.center = self.view.center;
    self.cameraView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cameraView];
    
    
    self.captureQueue = dispatch_queue_create("com.kimsungwhee.mosaiccamera.videoqueue", NULL);
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];;
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
    
    
    //遮罩图
    self.coverImgView = [[UIImageView alloc] initWithFrame:self.cameraView.bounds];
    [self.cameraView addSubview:self.coverImgView];
    self.coverImgView.image = [UIImage imageNamed:@"coverImg"];
    
    
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
    
}




- (void)beautify {
    [self.videoCamera removeAllTargets];

    //GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
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
        self.originImg = [UIImage imageWithData:imageData];
        self.renderImg = [self.beautifyFilter imageByFilteringImage:self.originImg];

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




@end
