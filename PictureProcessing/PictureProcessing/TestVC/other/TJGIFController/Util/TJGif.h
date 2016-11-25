//
//  TJGif.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJGif : NSObject


/** 分解gif图片 */
+ (void)decodeGif;


/** 生成gif图片 */
+ (void)encodeGif;


//返回保存图片的路径
+ (NSString *)backPath;

@end
