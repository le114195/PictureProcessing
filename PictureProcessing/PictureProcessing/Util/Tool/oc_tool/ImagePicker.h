//
//  ImagePicker.h
//  openCV
//
//  Created by 勒俊 on 16/9/1.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TJCompletionBlockOne)(id responseObject);

@interface ImagePicker : NSObject

/** 获取原图 */
- (void)getOriginImage:(UIViewController *)vc completion:(TJCompletionBlockOne)completion;


@end
