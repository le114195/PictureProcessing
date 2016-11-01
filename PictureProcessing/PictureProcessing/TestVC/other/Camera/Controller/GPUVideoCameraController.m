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

@interface GPUVideoCameraController ()<GPUImageVideoCameraDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) GPUImageVideoCamera       *videoCamera;
@property (nonatomic, strong) GPUImageView              *filterView;
@property (nonatomic, strong) UIButton                  *beautifyButton;
@property (strong, nonatomic) AVCaptureMetadataOutput   *medaDataOutput;
@property (strong, nonatomic) dispatch_queue_t          captureQueue;
@property (nonatomic, strong) NSArray                   *faceObjects;


@end

@implementation GPUVideoCameraController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.captureQueue = dispatch_queue_create("com.kimsungwhee.mosaiccamera.videoqueue", NULL);
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];;
    self.videoCamera.delegate = self;
    
    
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterView.center = self.view.center;
    
    [self.view addSubview:self.filterView];
    
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
    
    //Meta data
    self.medaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.videoCamera.captureSession canAddOutput:self.medaDataOutput]) {
        [self.videoCamera.captureSession addOutput:self.medaDataOutput];
        
        self.medaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        [self.medaDataOutput setMetadataObjectsDelegate:self queue:self.captureQueue];
    }
}



- (void)beautify {
    [self.videoCamera removeAllTargets];
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:self.filterView];
}



- (void)beautifyButtonAction {
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



#pragma mark - GPUImageVideoCameraDelegate代理方法

/** 用于输出图像 */
//GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CIImage *sourceImage;
    
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    sourceImage = [CIImage imageWithCVPixelBuffer:imageBuffer
                                          options:nil];
    
    UIImage *image;
    image = [self imageFromSampleBuffer:sampleBuffer];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    if (image) {
        //        NSLog(@"image ------------------------- %@",image);
    }
    return (image);
}


@end
