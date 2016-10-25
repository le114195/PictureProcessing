//
//  SSHTTP.m
//  TJSocial
//
//  Created by 勒俊 on 16/4/21.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "SSHTTP.h"

@implementation SSHTTP

+ (AFHTTPSessionManager *)sessionManager {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30.0f;//请求超时
    AFHTTPSessionManager *_sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
    _sessionManager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    [_sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]] forHTTPHeaderField:@"Accept-Language"];
    [_sessionManager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] forHTTPHeaderField:@"version"];
    [_sessionManager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"shortVersion"];
    return _sessionManager;
}

+ (NSURLSessionDataTask *)request:(SSRequestMethodType)methodType url:(NSString *)url parameters:(id)param success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(void))failure {

    NSURLSessionDataTask *task = nil;
    AFHTTPSessionManager *sessionManager = [self sessionManager];

    switch (methodType) {
        case SSRequestMethodTypePost:{
            task = [sessionManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * task, id responseObject) {
                
                if (success) {
                    success(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * task, NSError * error) {
                
                if (failure) {
                    failure();
                }
            }];
            break;
        }
        case SSRequestMethodTypeGet: {
            task = [sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    failure();
                }
            }];
            break;
        }
        default:
            break;
    }
    return task;

}



@end
