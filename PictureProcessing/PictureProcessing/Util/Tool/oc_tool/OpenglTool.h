//
//  OpenglTool.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>


@interface OpenglTool : NSObject


/** 从opengl es中读取gpu中的数据，并保存为UIImage */
+ (UIImage *)tj_glTOImageWithSize:(CGSize)ImgSize;






@end
