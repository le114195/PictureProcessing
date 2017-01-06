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
    
    [self makeVideo];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)makeVideo {
    
    NSMutableArray *imgs = [NSMutableArray array];
    [imgs addObject:[UIImage imageNamed:@"0.png"]];
    [imgs addObject:[UIImage imageNamed:@"1.png"]];
    [imgs addObject:[UIImage imageNamed:@"2.png"]];
    [imgs addObject:[UIImage imageNamed:@"3.png"]];
    [imgs addObject:[UIImage imageNamed:@"4.png"]];
    [imgs addObject:[UIImage imageNamed:@"5.png"]];
    [imgs addObject:[UIImage imageNamed:@"6.png"]];
    [imgs addObject:[UIImage imageNamed:@"7.png"]];
    [imgs addObject:[UIImage imageNamed:@"8.png"]];
    [imgs addObject:[UIImage imageNamed:@"9.png"]];
    [imgs addObject:[UIImage imageNamed:@"10.png"]];
    
    NSString *betaCompressionDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    
    unlink([betaCompressionDirectory UTF8String]);
    
    [self writeImages:imgs ToMovieAtPath:betaCompressionDirectory withSize:CGSizeMake(720, 720) inDuration:2.0 byFPS:30];
}



- (void)writeImages:(NSArray *)imagesArray ToMovieAtPath:(NSString *)path withSize:(CGSize) size
         inDuration:(float)duration byFPS:(int32_t)fps{
    //Wire the writer:
    NSError *error =nil;
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:path]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:
                                  AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput* videoWriterInput =[AVAssetWriterInput
                                           assetWriterInputWithMediaType:AVMediaTypeVideo
                                           outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                    assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                    sourcePixelBufferAttributes:nil];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //Write some samples:
    CVPixelBufferRef buffer =NULL;
    
    int frameCount = 0;
    
    NSUInteger imagesCount = [imagesArray count];
    float averageTime = duration/imagesCount;
    NSLog(@"averageTime--:%f",averageTime);
    int averageFrame =(int)(averageTime * fps);
    
    for(UIImage *img in imagesArray)
    {
        buffer=[self pixelBufferFromCGImage:[img CGImage]size:size];
        BOOL append_ok =NO;
        int j = 0;
        while (!append_ok)
        {
            if(adaptor.assetWriterInput.readyForMoreMediaData)
            {
                CMTime frameTime = CMTimeMake(frameCount,(int32_t)fps);
                float frameSeconds = CMTimeGetSeconds(frameTime);
                NSLog(@"frameCount:%d,kRecordingFPS:%d,frameSeconds:%f",frameCount,fps,frameSeconds);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                
                if(buffer)
                    [NSThread sleepForTimeInterval:0.05];
            }else{
                printf("adaptor not ready %d,%d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok){
            printf("error appendingimage %d times %d\n", frameCount, j);
        }
        
        frameCount = frameCount + averageFrame;
    }
    
    //Finish the session:
    [videoWriter finishWritingWithCompletionHandler:^{
        
    }];
    NSLog(@"finishWriting");
}


- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer !=NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    
    //    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    CGContextDrawImage(context, CGRectMake(0 + (size.width-CGImageGetWidth(image))/2,
                                           (size.height-CGImageGetHeight(image))/2,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    return pxbuffer;
    
}


@end
