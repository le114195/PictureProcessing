//
//  TJOpenGLVC3.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/19.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenGLVC3.h"
#import "TJOpenGL3View.h"

@implementation TJOpenGLVC3


- (void)viewDidLoad
{
    [super viewDidLoad];
    TJOpenGL3View *openglView = [[TJOpenGL3View alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:openglView];
    
    
    
}








@end
