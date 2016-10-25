//
//  TJURLSession.h
//  TJSocialNew
//
//  Created by 勒俊 on 16/10/8.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJURLSession : NSObject


+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;



/** post请求 */
+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters paths:(NSArray *)paths fieldName:(NSString *)fieldName completion:(CompletionBlock)completion;



+ (void)downLoadWithUrl:(NSString *)url parameters:(NSDictionary *)parameters progressBlock:(TJDownloaderProgressBlock)progressBlock completion:(CompletionBlock)completion;


@end
