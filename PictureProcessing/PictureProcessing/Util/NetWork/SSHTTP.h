//
//  SSHTTP.h
//  TJSocial
//
//  Created by 勒俊 on 16/4/21.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"




typedef NS_ENUM(NSInteger, SSRequestMethodType){
    SSRequestMethodTypePost,
    SSRequestMethodTypeGet,
};



@interface SSHTTP : NSObject

+ (AFHTTPSessionManager *)sessionManager;


+ (NSURLSessionDataTask *)request:(SSRequestMethodType)methodType url:(NSString *)url parameters:(id)param success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(void))failure;

@end
