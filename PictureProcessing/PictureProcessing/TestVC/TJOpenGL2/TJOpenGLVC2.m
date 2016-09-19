//
//  TJOpenGLVC2.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/13.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenGLVC2.h"
#import "OpenGLView1.h"

#define kPaletteSize			5


#define kBrightness             1.0
#define kSaturation             0.45


@interface TJOpenGLVC2 ()



@end

@implementation TJOpenGLVC2


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    
    OpenGLView1 *view = [[OpenGLView1 alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:view];
    
    
    
    
    CGColorRef color = [UIColor colorWithHue:(CGFloat)2.0 / (CGFloat)kPaletteSize
                                  saturation:kSaturation
                                  brightness:kBrightness
                                       alpha:1.0].CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    
    // Defer to the OpenGL view to set the brush color
    [view setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    
    
}




@end
