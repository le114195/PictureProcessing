//
//  TJGIFController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/21.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJGIFController.h"
#import "TJ_PosterContainerView.h"

#import <TJSDM/FaceLandmarkInterface.h>

#import <opencv2/imgcodecs/ios.h>
#import <opencv2/opencv.hpp>
#import "TJ_PosterView.h"
#import "GDataXMLNode.h"
#import "UIImage+TJ.h"
#import "TJ_PointConver.h"
#import "TJPosterModel.h"



@interface TJGIFController ()

@property (nonatomic, strong) TJ_PosterContainerView           *containerView;

@property (nonatomic, strong) NSMutableArray                    *posterArrM;

@property (nonatomic, strong) NSMutableArray                    *ImgArray;

@property (nonatomic, strong) UIImage                           *tj_image;

@end

@implementation TJGIFController
{
    CGFloat         backWidth;
    CGFloat         backHeight;
    NSArray         *keyPoint;
    
    CGPoint         point_8;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.posterArrM = [NSMutableArray array];
    self.ImgArray = [NSMutableArray array];
    
    self.tj_image = [UIImage imageNamed:@"expression_face"];
    keyPoint = [FaceLandmarkInterface getLanmarkPointFromUIImage:self.tj_image];
    
    point_8 = CGPointMake([keyPoint[8] floatValue], [keyPoint[keyPoint.count / 2 + 8] floatValue]);
    point_8 = CGPointMake(point_8.x - self.tj_image.size.width * 0.5, point_8.y - self.tj_image.size.height * 0.5);
    
    
    [self addPoster];
    
    
    [self test];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    NSMutableArray *imageArrM = [NSMutableArray array];
    
    for (int i = 0; i < 13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
        [imageArrM addObject:image];
    }
    
    //650*366
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
    gifImageView.animationImages = self.ImgArray; //获取Gif图片列表
    gifImageView.animationDuration = 2.5;     //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 100;  //动画重复次数
    [gifImageView startAnimating];
    [self.view addSubview:gifImageView];
}



#pragma mark - 子控件初始化



#pragma mark - 数据初始化


- (void)addPoster
{
    NSDictionary *rootDict = [self decodeXml];
    backHeight = [[rootDict valueForKey:@"backHeight"] floatValue];
    backWidth = [[rootDict valueForKey:@"backWidth"] floatValue];
    
    NSArray *array = [rootDict valueForKey:@"ImgArray"];
    
    NSDictionary *dict = array[3];
    
    [self pictureWithDict:dict];
    
    
    for (NSDictionary *modelDict in array) {
        NSArray *modelArray = [TJPosterModel modelWithDict:modelDict faceImg:self.tj_image point8:point_8 backWidth:backWidth backHeight:backHeight];
        UIImage *newImg = [self drawImageWithPosterModels:modelArray];
        [self.ImgArray addObject:newImg];
    }
}

- (void)pictureWithDict:(NSDictionary*)dict
{
    NSArray *modelArray = [TJPosterModel modelWithDict:dict faceImg:self.tj_image point8:point_8 backWidth:backWidth backHeight:backHeight];
    
    for (TJPosterModel *model in modelArray) {
        
        if ([model.nodeName isEqualToString:@"TJBackgroundLayer"]) {
            
            TJ_PosterView *posterBGView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
            posterBGView.userInteractionEnabled = NO;
            [self.containerView addSubview:posterBGView];
            posterBGView.image = model.tj_image;
            
        }else if ([model.nodeName isEqualToString:@"TJFaceLayer"]) {
            
            TJ_PosterView *posterView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 0, self.tj_image.size.width * (Screen_Width / backWidth), self.tj_image.size.height * (Screen_Width / backWidth))];
            [posterView setCenter:CGPointMake(backWidth * 0.5 * (Screen_Width / backWidth), backHeight * 0.5 * (Screen_Width / backWidth))];
            [self.containerView addSubview:posterView];
            posterView.image = self.tj_image;
            
            //缩放
            posterView.transform = CGAffineTransformScale(posterView.transform, model.tj_scale, model.tj_scale);
            
            //旋转
            posterView.transform = CGAffineTransformRotate(posterView.transform, model.tj_angle);
            
            //平移
            [posterView setCenter:CGPointMake((model.tj_center.x + backWidth * 0.5) * (Screen_Width / backWidth), (model.tj_center.y + backHeight * 0.5) * (Screen_Width / backWidth))];
            
        }
    }
    
    [self drawImageWithPosterModels:modelArray];
    
}



- (NSDictionary *)decodeXml
{
    
    NSMutableDictionary *rootDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"1479719953719c400010m400010.xml" ofType:nil];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *document =  [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    
    for (int i = 0; i < rootElement.attributes.count; i++) {
        NSString *key = [rootElement.attributes[i] name];
        NSString *value = [rootElement.attributes[i] stringValue];
        rootDict[key] = value;
    }
    
    NSArray *array = [rootElement children];
    for (GDataXMLElement *element in array) {
        
        NSMutableDictionary *eleDict = [NSMutableDictionary dictionary];
        [eleDict setValue:[[element.attributes firstObject] stringValue] forKey:@"time"];
        
        NSMutableArray *dictArr = [NSMutableArray array];
        
        NSArray *eleArr = [element children];
        
        for (GDataXMLElement *imgEle in eleArr) {
            // 根据标签名判断
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            // 标签名
            tempDic[@"nodeName"] = [imgEle name];
            // 标签内容
            if([imgEle stringValue].length != 0){
                tempDic[@"nodeValue"] = [imgEle stringValue];
            }
            // 标签属性
            for (int i = 0; i < imgEle.attributes.count; i++) {
                NSString *key = [imgEle.attributes[i] name];
                NSString *value = [imgEle.attributes[i] stringValue];
                tempDic[key] = value;
            }
            [dictArr addObject:tempDic];
        }
        [eleDict setValue:dictArr forKey:@"result"];
        [arrM addObject:eleDict];
    }
    
    [rootDict setValue:arrM forKey:@"ImgArray"];
    
    return rootDict;
}


#pragma mark - set/get

- (TJ_PosterContainerView *)containerView
{
    if (!_containerView) {
        _containerView = [[TJ_PosterContainerView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
        [_containerView setCenter:CGPointMake(Screen_Width * 0.5,Screen_Height * 0.5)];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}




#pragma mark - 点击事件




#pragma mark - 代理方法



#pragma mark - 私有方法

/** 画图 */
- (UIImage *)drawImageWithPosterModels:(NSArray *)models
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(backWidth, backHeight), NO, 1.0);
    for (TJPosterModel *model in models) {
        if (model.tj_image == nil) continue;
        [model.tj_image drawAtCenter:CGPointMake(model.tj_center.x + backWidth * 0.5, model.tj_center.y + backHeight * 0.5) Alpha:1.0 withTranslation:CGPointMake(0, 0) radian:model.tj_angle scale:model.tj_scale];
        
    }
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}




@end
