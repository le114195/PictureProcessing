//
//  UIImage+TJ.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "UIImage+TJ.h"

@implementation UIImage (TJ)


- (void)saveImageWithImgName:(NSString *)imgName imageType:(int)imageType
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = nil;
    if (imageType) {
        imageData = UIImagePNGRepresentation(self);
    }else {
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }
    [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", ToolDirectory, imgName] contents:imageData attributes:nil];
}



@end
