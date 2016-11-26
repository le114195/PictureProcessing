//
//  FaceLandmarkInterface.h
//  TJSDM
//
//  Created by 崔海港 on 2016/11/23.
//  Copyright © 2016年 崔海港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceLandmarkInterface : NSObject

/**
 获取人脸关键点

 @param faceImage 人脸原图
 @return 68个关键点位置的一维数组，字符串类型（共136个值，前68为x坐标，后68为y坐标）；未检测到人脸返回nil
 */
+(NSMutableArray *)getLanmarkPointFromUIImage:(UIImage *)faceImage;


/**
 裁切mask图（只获得扣出的区域）

 @param maskImage mask图，黑白的
 @return 返回裁切位置（x,y,width,height）
 */
+(CGRect)getSubstanceRect:(UIImage *)maskImage;

@end
