//
//  TJSessionDelegate.h
//  TJSocialNew
//
//  Created by 勒俊 on 16/10/8.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJSessionDelegate : NSObject<NSURLSessionDelegate>

@property (nonatomic, copy) TJDownloaderProgressBlock       progressBlock;

@property (nonatomic, copy) CompletionBlock                 completionBlock;

@end
