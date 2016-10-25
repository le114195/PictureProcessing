//
//  TJSSHTTPBase.m
//  TJSocialNew
//
//  Created by 勒俊 on 16/6/7.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJSSHTTPBase.h"
#import "SSHTTP.h"

@implementation TJSSHTTPBase


+ (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
    [SSHTTP request:(SSRequestMethodTypePost) url:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *status = [responseObject valueForKey:@"status"];
        if (status.intValue == 1) {
            if (completion) {
                completion(responseObject, 1);
            }
        }else {
            if (completion) {
                completion(responseObject, status.intValue);
            }
        }
    } failure:^{
        if (completion) {
            completion(nil, -1);
        }
    }];
}





@end
