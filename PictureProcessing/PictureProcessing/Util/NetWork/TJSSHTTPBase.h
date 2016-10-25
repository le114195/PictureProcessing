//
//  TJSSHTTPBase.h
//  TJSocialNew
//
//  Created by 勒俊 on 16/6/7.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TJSSHTTPBase : NSObject

+ (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

@end
