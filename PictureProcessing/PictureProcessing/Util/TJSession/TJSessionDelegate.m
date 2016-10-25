//
//  TJSessionDelegate.m
//  TJSocialNew
//
//  Created by 勒俊 on 16/10/8.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJSessionDelegate.h"

@implementation TJSessionDelegate


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (self.completionBlock) {
        self.completionBlock(data, 1);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (_progressBlock) {
        _progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (self.completionBlock) {
        self.completionBlock(nil, -1);
    }
}




@end
