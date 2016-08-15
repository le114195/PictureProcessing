//
//  FileHeader.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/15.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef FileHeader_h
#define FileHeader_h



#define ToolDirectory       [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tool"]
#define PictureHeader(imageName)       [[NSBundle mainBundle] pathForResource:imageName ofType:nil]


#endif /* FileHeader_h */
