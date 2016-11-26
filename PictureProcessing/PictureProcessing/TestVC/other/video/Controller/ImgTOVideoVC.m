//
//  ImgTOVideoVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "ImgTOVideoVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ImgTOVideoVC ()

@end

@implementation ImgTOVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testCompressionSession];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) testCompressionSession

{
    
    NSArray *imageArr = [NSArray arrayWithObjects:[[UIImage imageNamed:@"sj_20160705_10.JPG"] CGImage],[[UIImage imageNamed:@"sj_20160705_11.JPG"] CGImage],[[UIImage imageNamed:@"sj_20160705_12.JPG"] CGImage],[[UIImage imageNamed:@"sj_20160705_13.JPG"] CGImage],[[UIImage imageNamed:@"sj_20160705_14.JPG"] CGImage], nil];
    
    
    
    CGSize size = CGSizeMake(1080, 1920);
    
    
    
    
    
    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    
    
    
    NSError *error = nil;
    
    
    
    unlink([betaCompressionDirectory UTF8String]);
    
    
    
    //----initialize compression engine
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:betaCompressionDirectory]
                                  
                                                           fileType:AVFileTypeQuickTimeMovie
                                  
                                                              error:&error];
    
    NSParameterAssert(videoWriter);
    
    if(error)
        
        NSLog(@"error = %@", [error localizedDescription]);
    
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           
                                                           [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     
                                                                                                                     sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    NSParameterAssert(writerInput);
    
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    
    
    if ([videoWriter canAddInput:writerInput])
        
        NSLog(@"I can add this input");
    
    else
        
        NSLog(@"i can't add this input");
    
    
    
    [videoWriter addInput:writerInput];
    
    
    
    [videoWriter startWriting];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    
    //---
    
    // insert demo debugging code to write the same image repeated as a movie
    
    dispatch_queue_t    dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    int __block         frame = 0;
    
    
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        
        while ([writerInput isReadyForMoreMediaData])
            
        {
            
            if(++frame >= imageArr.count * 40)
                
            {
                
                [writerInput markAsFinished];
                
                [videoWriter finishWriting];
                
                
                
                break;
                
            }
            
            int idx = frame/40;
            
            
            
            CVPixelBufferRef buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:(__bridge CGImageRef)([imageArr objectAtIndex:idx]) size:size];
            
            if (buffer)
                
            {
                
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 20)])
                    
                    NSLog(@"FAIL");
                
                else
                    
                    NSLog(@"Success:%d", frame);
                
                CFRelease(buffer);
                
            }
            
        }
        
    }];
    
    
    
    NSLog(@"outside for loop");
    
}





- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size

{
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    // CVReturn status = CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &pxbuffer);
    
    
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
    
}

@end
