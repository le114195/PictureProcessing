//
//  TJOpenglesVC.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/1/18.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "TJOpenglesVC.h"
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

@interface TJOpenglesVC ()

@property (nonatomic, weak) PaintTypeView       *paintTypeView;

@end

@implementation TJOpenglesVC



+ (instancetype)openglesVCWithIndex:(NSInteger)index
{
    TJOpenglesVC *openglesVC = [[TJOpenglesVC alloc] init];
    
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
            [self demo1];
            break;
        case 1:
            [self demo2];
            break;
        case 2:
            [self demo3];
            break;
        case 3:
            [self demo4];
            break;
        case 4:
            [self demo5];
            break;
        case 5:
            [self demo6];
            break;
        case 6:
            [self textureTest];
            break;
        default:
            break;
    }
}


#pragma mark - 测试
- (void)demo1
{
    TJOpenglesDemo1 *demo1 = [[TJOpenglesDemo1 alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64)];
    [self.view addSubview:demo1];
}


- (void)demo2
{
    TJOpengles3D *demo2 = [[TJOpengles3D alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:demo2];
}


/** 对图片进行透视、平移和旋转 */
- (void)demo3
{
    TJOpenglesTrangle *demo3 = [[TJOpenglesTrangle alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    
    [self.view addSubview:demo3];
}


/** 多边形 */
- (void)demo4
{
    TJOpenglesRect *demo4 = [[TJOpenglesRect alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:demo4];
}


- (void)demo5
{
    TJOpenglesNewRect *demo4 = [[TJOpenglesNewRect alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:demo4];
}

- (void)demo6
{
    TJopenglesText2D1 *demo6 = [[TJopenglesText2D1 alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:demo6];
}




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




@end
