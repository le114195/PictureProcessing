//
//  TextureBaseController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TextureBaseController.h"
#import "TJOpenglesDemo1.h"
#import "TJOpenglesBrushView.h"
#import "PaintTypeView.h"
#import "PaintTypeModel.h"
#import "TJOpengles3D.h"
#import "TJOpenglesTrangle.h"
#import "TJOpenglesRect.h"
#import "TJOpenglesNewRect.h"
#import "TJopenglesText2D1.h"
#import "TJOpenglesCurve.h"
#import "TJ_TextureTest.h"
#import "TwoTextureView.h"
#import "TJ3DView.h"
#import "MultiTextureView.h"

@interface TextureBaseController ()

@end

@implementation TextureBaseController

+ (instancetype)openglesVCWithIndex:(NSInteger)index
{
    TextureBaseController *openglesVC = [[TextureBaseController alloc] init];
    
    [openglesVC demoWithIndex:index];
    
    return openglesVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self textureTest];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)demoWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self textureTest];
            break;
        case 1:
            [self twoTexture];
            break;
        case 2:
            [self multiTexture];
        default:
            break;
    }
}


#pragma mark - 测试
/** 纹理测试 */
- (void)textureTest
{
    //IMG_0991.JPG
    //IMG_0992.JPG
    //IMG_0994.JPG
    //IMG_4619.JPG
    //IMG_0944.JPG
    //sj_20160705_9.JPG
    UIImage *image = [UIImage imageNamed:@"IMG_0994.JPG"];
    TJ_TextureTest *texture = [[TJ_TextureTest alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:texture];
}


- (void)twoTexture
{
    UIImage *image = [UIImage imageNamed:@"sj_20160705_10.JPG"];
    TwoTextureView *twoTexture = [[TwoTextureView alloc] initWithFrame:[self resetImageViewFrameWithImage:image top:64 bottom:0] image:image];
    [self.view addSubview:twoTexture];
}



- (void)multiTexture
{
    CGFloat marginX = 32 * Screen_Width / Screen_Height;
    MultiTextureView *multiTexture = [[MultiTextureView alloc] initWithFrame:CGRectMake(marginX, 64, Screen_Width - 2 * marginX, Screen_Height - 64)];
    [self.view addSubview:multiTexture];
}


@end
