//
//  TJOPenGL2VC.h
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/12.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface TJOPenGL2VC : GLKViewController
{
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;


@end
