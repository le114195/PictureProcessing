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
    
    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautifyButton.backgroundColor = [UIColor whiteColor];
    [self.beautifyButton setTitle:@"翻转" forState:UIControlStateNormal];
    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautifyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautifyButton];
    [self.beautifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
    }];
    
    [self beautify];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    if ([self.videoCamera.captureSession canAddOutput:self.ImageOutPut]) {
        [self.videoCamera.captureSession addOutput:self.ImageOutPut];
    }

}



- (void)beautify {
    [self.videoCamera removeAllTargets];

    //GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    self.beautifyFilter = [[TJ_GPUBeautifyFilter alloc] init];
    
    [self.videoCamera addTarget:self.beautifyFilter];
    [self.beautifyFilter addTarget:self.filterView];
}



- (void)beautifyButtonAction {
    
    
    [self shutterCamera];
    return;
    
    NSLog(@"做个动画");
    [self.videoCamera rotateCamera];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
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
    

#pragma mark - GPUImageVideoCameraDelegate代理方法
/** 用于输出图像 */
//GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    
    
}




@end
