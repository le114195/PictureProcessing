//
//  OpenglTool.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "OpenglTool.h"
#import <GLKit/GLKit.h>

@implementation OpenglTool


+ (UIImage *)tj_glTOImageWithSize:(CGSize)ImgSize
{
    NSInteger myDataLength = ImgSize.width * ImgSize.height * 4;
    GLubyte * buffer = (GLubyte*) malloc(myDataLength);
    memset(buffer, 0, myDataLength);
    
    glReadPixels(0,
                 0,
                 ImgSize.width,
                 ImgSize.height,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 buffer);
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              buffer,
                                                              myDataLength,
                                                              NULL);
    
    CGImageRef iref = CGImageCreate(ImgSize.width,
                                    ImgSize.height,
                                    8,
                                    32,
                                    ImgSize.width * 4,
                                    CGColorSpaceCreateDeviceRGB(),
                                    kCGBitmapByteOrderDefault | kCGImageAlphaLast,
                                    provider,
                                    NULL,
                                    NO,
                                    kCGRenderingIntentDefault);
    
    
    size_t wi         = CGImageGetWidth(iref);
    size_t he        = CGImageGetHeight(iref);
    UIGraphicsBeginImageContext(CGSizeMake(wi, he));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, wi, he), iref);
    UIImage* outputImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGDataProviderRelease(provider);
    CGImageRelease(iref);
    free(buffer);
    buffer = NULL;
    return outputImage;
}





@end
