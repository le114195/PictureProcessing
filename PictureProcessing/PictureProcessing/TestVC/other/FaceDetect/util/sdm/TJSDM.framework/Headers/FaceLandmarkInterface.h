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

-(NSMutableArray *)getLanmarkPointFromUIImage:(UIImage *)faceImage;

@end
