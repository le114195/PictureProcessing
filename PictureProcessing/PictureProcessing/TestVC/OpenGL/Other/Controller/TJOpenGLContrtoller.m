//
//  TJOpenGLContrtoller.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/9/23.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenGLContrtoller.h"
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







@interface TJOpenGLContrtoller ()


@property (nonatomic, weak) PaintTypeView       *paintTypeView;


@end

@implementation TJOpenGLContrtoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self textureTest];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)paintTypeViewConfigure
{
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSDictionary *dict1 = @{@"name":@"画笔1", @"imgName":@"paint1"};
    PaintTypeModel *model1 = [PaintTypeModel modelWithDict:dict1];
    
    NSDictionary *dict2 = @{@"name":@"画笔2", @"imgName":@"paint2"};
    PaintTypeModel *model2 = [PaintTypeModel modelWithDict:dict2];
    
    
    [arrM addObject:model1];
    [arrM addObject:model2];
    
    PaintTypeView *paintTypeView = [[PaintTypeView alloc] initWithFrame:CGRectMake(0, Screen_Height - 64, Screen_Width, 64)];
    self.paintTypeView = paintTypeView;
    
    paintTypeView.dataArray = arrM;
    [self.view addSubview:paintTypeView];
    
    __weak __typeof(self)weakSelf = self;
    paintTypeView.didSelectBlock = ^(NSInteger index){
        [weakSelf didSelect:index];
    };
    
}

- (void)didSelect:(NSInteger)index
{
    
    
    
    
    
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
