//
//  BlockHeader.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef BlockHeader_h
#define BlockHeader_h



#define tj_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(id responseObject, int status);
typedef void(^TJDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);



#endif /* BlockHeader_h */
