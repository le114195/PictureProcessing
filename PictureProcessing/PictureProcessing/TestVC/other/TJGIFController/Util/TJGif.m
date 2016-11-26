//
//  TJGif.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJGif.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation TJGif



/** 分解gif图片 */
+ (void)decodeGif
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"testGif" ofType:@"gif"]];
    //通过data获取image的数据源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //获取帧数
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    for (size_t i = 0; i < count; i++)
    {
        //获取图像
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        //生成image
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        [tmpArray addObject:image];
        
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    
    int i = 0;
    for (UIImage *img in tmpArray) {
        //写文件
        NSData *imageData = UIImagePNGRepresentation(img);
        
        NSString *pathNum = [[self backPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]];
        [imageData writeToFile:pathNum atomically:NO];
        i++;
    }
}


//返回保存图片的路径
+ (NSString *)backPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imageDirectory = [ToolDirectory stringByAppendingPathComponent:@"Normal"];
    [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return imageDirectory;
}


/** 生成gif图片 */
+ (void)encodeGif
{
    //获取源数据image
    NSMutableArray *imgs = [NSMutableArray array];
    for (int i = 0; i < 13; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d", i];
        [imgs addObject:[UIImage imageNamed:imgName]];
    }
    //图像目标
    CGImageDestinationRef destination;
    
    //创建输出路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [ToolDirectory stringByAppendingPathComponent:@"gif"];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDirectory stringByAppendingPathComponent:@"test101.gif"];
    
    NSLog(@"%@",path);
    
    
    //创建CFURL对象
    /*
     CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
     
     allocator : 分配器,通常使用kCFAllocatorDefault
     filePath : 路径
     pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
     isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
     */
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)path,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.2], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in imgs)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
}



@end
