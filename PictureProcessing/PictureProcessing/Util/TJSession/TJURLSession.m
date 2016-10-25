//
//  TJURLSession.m
//  TJSocialNew
//
//  Created by 勒俊 on 16/10/8.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJURLSession.h"
#import "TJSessionDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TJURLSession ()

@end

@implementation TJURLSession

+ (NSURLSession *)sessionManager {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30.0f;//请求超时
    NSURLSession *sessionManager = [NSURLSession sessionWithConfiguration:config];
    return sessionManager;
}

+ (NSURLSessionConfiguration *)sessionConfigure
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30.0f;//请求超时
    return config;
}



+ (NSMutableURLRequest *)request:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    request.timeoutInterval = 30.0;
    request.HTTPMethod = @"POST";
    
    NSMutableString *parameterString = [NSMutableString string];
    for (NSString *key in parameters.allKeys) {
        // 拼接字符串
        [parameterString appendFormat:@"%@=%@&", key, parameters[key]];
    }
    //截取参数字符串，去掉最后一个“&”，并且将其转成NSData数据类型。
    NSData *parametersData = [[parameterString substringToIndex:parameterString.length - 1] dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = parametersData;
    
    return request;
}

/** post multipart/form-data的方式上传 */
+ (NSMutableURLRequest *)request:(NSURL *)URL
                      parameters:(NSDictionary *)parameters
                           paths:(NSArray *)paths
                       fieldName:(NSString *)fieldName
{
    // configure the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"tj_boundary";
    
    // set content type
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    request.HTTPBody = [self createBodyWithBoundary:boundary parameters:parameters paths:paths fieldName:fieldName];
    
    return request;
}


/** post请求 */
+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters paths:(NSArray *)paths fieldName:(NSString *)fieldName completion:(CompletionBlock)completion
{
    NSURL *URL = [NSURL URLWithString:url];
    // 2、创建Reuest请求
    NSMutableURLRequest *request = [self request:URL parameters:parameters paths:paths fieldName:fieldName];
    
    NSURLSessionTask *task = [[self sessionManager] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 10、判断是否请求成功
        if (error) {
            if (completion) {
                completion(nil, -1);
            }
        }else {
            // 如果请求成功，则解析数据。
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 11、判断是否解析成功
            if (error) {
                if (completion) {
                    completion(object, -1);
                }
            }else {
                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面...
                    if (completion) {
                        completion(object, 1);
                    }
                });
            }
        }
    }];
    // 9、执行任务
    [task resume];
}




/** post请求 */
+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
    NSURL *URL = [NSURL URLWithString:url];
    // 2、创建Reuest请求
    NSMutableURLRequest *request = [self request:URL parameters:parameters];
    
    NSURLSessionTask *task = [[self sessionManager] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 10、判断是否请求成功
        if (error) {
            if (completion) {
                completion(nil, -1);
            }
        }else {
            // 如果请求成功，则解析数据。
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            // 11、判断是否解析成功
            if (error) {
                if (completion) {
                    completion(object, -1);
                }
            }else {
                // 解析成功，处理数据，通过GCD获取主队列，在主线程中刷新界面。
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新界面...
                    if (completion) {
                        completion(object, 1);
                    }
                });
            }
        }
    }];
    // 9、执行任务
    [task resume];
}

/** 下载文件 */
+ (void)downLoadWithUrl:(NSString *)url parameters:(NSDictionary *)parameters progressBlock:(TJDownloaderProgressBlock)progressBlock completion:(CompletionBlock)completion
{
    NSURL *URL = [NSURL URLWithString:url];
    // 2、创建Reuest请求
    NSMutableURLRequest *request = [self request:URL parameters:parameters];
    
    TJSessionDelegate *downDelegate = [[TJSessionDelegate alloc] init];
    downDelegate.progressBlock = progressBlock;
    downDelegate.completionBlock = completion;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfigure] delegate:downDelegate delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request];
    [downTask resume];
}




#pragma mark - test
+ (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


+ (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}






@end
