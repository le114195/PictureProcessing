//
//  BrushBaseController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "BrushBaseController.h"
#import "TJOpenglesBrushView.h"
#import "OpenGLBrushDemo1.h"
#import "OpenGLBrushDemo2.h"


@interface BrushBaseController ()

@end

@implementation BrushBaseController

+ (instancetype)openglesVCWithIndex:(NSInteger)index
{
    BrushBaseController *openglesVC = [[BrushBaseController alloc] init];
    [openglesVC demoWithIndex:index];
    return openglesVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)demoWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            [self brush];
            break;
        case 1:
            [self brush2];
            break;
        case 2:
            [self brush3];
            break;
            
        default:
            break;
    }
}


/** 画笔1 */
- (void)brush
{
    TJOpenglesBrushView *brushView = [[TJOpenglesBrushView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:brushView];
    
    CGFloat kPaletteSize = 5.0;
    CGFloat kSaturation = 0.45;
    CGFloat kBrightness = 1.0;
    
    // Define a starting color
    CGColorRef color = [UIColor colorWithHue:(CGFloat)2.0 / kPaletteSize
                                  saturation:kSaturation
                                  brightness:kBrightness
                                       alpha:1.0].CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    
    // Defer to the OpenGL view to set the brush color
    [brushView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
}


- (void)brush2
{
    OpenGLBrushDemo1 *brush2 = [[OpenGLBrushDemo1 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:brush2];
}

- (void)brush3 {
    
    OpenGLBrushDemo2 *demo2 = [[OpenGLBrushDemo2 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:demo2];
}




@end
