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
#import "TJShowGIFController.h"



@interface TJGIFController ()

@property (nonatomic, strong) TJ_PosterContainerView           *containerView;

@property (nonatomic, strong) NSMutableArray                    *posterImgViewArrM;

@property (nonatomic, strong) UIImage                           *tj_image;

@property (nonatomic, strong) NSArray                           *dictArray;

@property (nonatomic, assign) int                               currentIndex;

@property (nonatomic, strong) NSMutableArray                    *poster2ModelArrM;

@property (nonatomic, strong) NSArray                           *firstPosterModelArray;


@end

@implementation TJGIFController
{
    CGFloat         backWidth;
    CGFloat         backHeight;
    NSArray         *keyPoint;
    
    CGPoint         point_8;
    
    CGFloat         faceWidth;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.poster2ModelArrM = [NSMutableArray array];
    self.posterImgViewArrM = [NSMutableArray array];
    
    [self faceDetect];
    
    [self addPoster];
    
    [self showBtnConfigure];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapActionNotification:) name:@"TJ_PosterTapGestureNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 子控件初始化


- (void)showBtnConfigure
{
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, Screen_Height - 60, Screen_Width, 60)];
    [self.view addSubview:showBtn];
    [showBtn setTitle:@"预览" forState:UIControlStateNormal];
    showBtn.backgroundColor = [UIColor blueColor];
    
    [showBtn setTintColor:[UIColor blackColor]];
    
    [showBtn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 数据初始化

/** 人脸检测 */
- (void)faceDetect
{
    self.tj_image = [UIImage imageNamed:@"rgba1475982568575c1000007m10000071"];
    keyPoint = [FaceLandmarkInterface getLanmarkPointFromUIImage:self.tj_image];
    
    if (keyPoint.count * 0.5 < 68) {
        point_8 = CGPointMake(0, 0);
        faceWidth = self.tj_image.size.width * 0.5;
    }else {
        point_8 = CGPointMake([keyPoint[8] floatValue], [keyPoint[keyPoint.count / 2 + 8] floatValue]);
        point_8 = CGPointMake(point_8.x - self.tj_image.size.width * 0.5, point_8.y - self.tj_image.size.height * 0.5);
        
        CGPoint point_1 = CGPointMake([keyPoint[1] floatValue], [keyPoint[keyPoint.count / 2 + 1] floatValue]);
        CGPoint point_15 = CGPointMake([keyPoint[15] floatValue], [keyPoint[keyPoint.count / 2 + 15] floatValue]);
        
        faceWidth = sqrt((point_1.x - point_15.x) * (point_1.x - point_15.x) + (point_1.y - point_15.y) * (point_1.y - point_15.y));
    }

}


- (void)addPoster
{
    NSDictionary *rootDict = [self decodeXml];
    backHeight = [[rootDict valueForKey:@"backHeight"] floatValue];
    backWidth = [[rootDict valueForKey:@"backWidth"] floatValue];
    
    self.dictArray = [rootDict valueForKey:@"ImgArray"];
    
    NSDictionary *dict = [self.dictArray firstObject];
    [self pictureWithDict:dict];
    
    for (NSDictionary *modelDict in self.dictArray) {
        NSArray *modelArray = [TJPosterModel modelWithDict:modelDict faceImg:self.tj_image faceWidth:faceWidth point8:point_8 backWidth:backWidth backHeight:backHeight];
        [self.poster2ModelArrM addObject:modelArray];
    }
}


/** 输出图片数组 */
- (NSArray *)drawImgArray
{
    NSMutableArray *ImgArray = [NSMutableArray array];
    for (NSArray *modelArray in self.poster2ModelArrM) {
        UIImage *newImg = [self drawImageWithPosterModels:modelArray];
        [ImgArray addObject:newImg];
    }
    return ImgArray;
}


- (void)pictureWithDict:(NSDictionary*)dict
{
    NSArray *modelArray = [TJPosterModel modelWithDict:dict faceImg:self.tj_image faceWidth:faceWidth point8:point_8 backWidth:backWidth backHeight:backHeight];
    self.firstPosterModelArray = modelArray;
    
    for (TJPosterModel *model in modelArray) {
        
        if ([model.nodeName isEqualToString:@"TJBackgroundLayer"]) {
            
            TJ_PosterView *posterBGView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
            posterBGView.userInteractionEnabled = NO;
            [self.containerView addSubview:posterBGView];
            posterBGView.image = model.tj_image;
            [self.posterImgViewArrM addObject:posterBGView];
        }else if ([model.nodeName isEqualToString:@"TJFaceLayer"]) {
            
            TJ_PosterView *posterView = [[TJ_PosterView alloc] initWithFrame:CGRectMake(0, 0, self.tj_image.size.width * (Screen_Width / backWidth), self.tj_image.size.height * (Screen_Width / backWidth))];
            [posterView setCenter:CGPointMake(backWidth * 0.5 * (Screen_Width / backWidth), backHeight * 0.5 * (Screen_Width / backWidth))];
            [self.containerView addSubview:posterView];
            posterView.image = self.tj_image;
            
            //缩放
            posterView.transform = CGAffineTransformScale(posterView.transform, model.tj_scale, model.tj_scale);
            posterView.tj_scale *= model.tj_scale;
            
            //旋转
            posterView.transform = CGAffineTransformRotate(posterView.transform, model.tj_angle);
            posterView.tj_angle += model.tj_angle;
            
            //平移
            [posterView setCenter:CGPointMake((model.tj_center.x + backWidth * 0.5) * (Screen_Width / backWidth), (model.tj_center.y + backHeight * 0.5) * (Screen_Width / backWidth))];
            
            [self.posterImgViewArrM addObject:posterView];
        }
    }
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
        
        __weak __typeof(self)weakSelf = self;
        _containerView.scaleBlock = ^(CGFloat scale){
            [weakSelf scaleAction:scale];
        };
        _containerView.rotateBlock = ^(CGFloat angle){
            [weakSelf rotationAction:angle];
        };
        _containerView.translationBlock = ^(CGPoint offset){
            [weakSelf translationAction:offset];
        };
    }
    return _containerView;
}




#pragma mark - 点击事件

- (void)showAction
{
    for (int i = 0; i < self.posterImgViewArrM.count; i++) {
        
        for (NSArray *modelArray in self.poster2ModelArrM) {
            TJPosterModel *model = modelArray[i];
            

            if (model.referenceObject == 1) {
                CGPoint newPoint8 = [TJ_PointConver tj_conver:point_8 scale:model.tj_scale angle:model.tj_angle];
                CGPoint offset = CGPointMake((newPoint8.x - model.location.x), (newPoint8.y - model.location.y));

                model.tj_center = CGPointMake(-offset.x - model.tj_offset.x, -offset.y - model.tj_offset.y);
                
                
            }
            

        }
    }
    
    
    
    TJShowGIFController *showVC = [TJShowGIFController showWithImgArray:[self drawImgArray]];
    
    [self.navigationController pushViewController:showVC animated:YES];
}


#pragma mark - 消息通知事件
- (void)tapActionNotification:(NSNotification *)notiP
{
    TJ_PosterView *selectPosterView = (TJ_PosterView*)[notiP object];
    for (int i = 0; i < self.posterImgViewArrM.count; i++) {
        TJ_PosterView *posterView = self.posterImgViewArrM[i];
        if ([posterView isEqual:selectPosterView]) {
            self.currentIndex = i;
            break;
        }
    }
    NSLog(@"currentIndex = %d", self.currentIndex);
}



#pragma mark - 代理方法



#pragma mark - 私有方法

- (void)scaleAction:(CGFloat)scale
{
    for (NSArray *modelArray in self.poster2ModelArrM) {
        TJPosterModel *model = modelArray[self.currentIndex];
        
        
        model.tj_scale = self.containerView.currentPoster.tj_scale;
        
        if (model.referenceObject == 1) {
            CGPoint newPoint8 = [TJ_PointConver tj_conver:point_8 scale:model.tj_scale angle:model.tj_angle];
            CGPoint offset = CGPointMake((newPoint8.x - model.location.x), (newPoint8.y - model.location.y));
            
            model.tj_offset = CGPointMake(model.tj_offset.x + (-offset.x - model.tj_center.x), model.tj_offset.y + (-offset.y - model.tj_center.y));
            model.tj_center = CGPointMake(-offset.x, -offset.y);
            
        }
    }
}

- (void)rotationAction:(CGFloat)angle
{
    for (NSArray *modelArray in self.poster2ModelArrM) {
        TJPosterModel *model = modelArray[self.currentIndex];
        model.tj_angle += angle;
        
        if (model.referenceObject == 1) {
            CGPoint newPoint8 = [TJ_PointConver tj_conver:point_8 scale:model.tj_scale angle:model.tj_angle];
            CGPoint offset = CGPointMake((newPoint8.x - model.location.x), (newPoint8.y - model.location.y));

            model.tj_offset = CGPointMake(model.tj_offset.x + (-offset.x - model.tj_center.x), model.tj_offset.y + (-offset.y - model.tj_center.y));
            model.tj_center = CGPointMake(-offset.x, -offset.y);
            
        }
    }
}

- (void)translationAction:(CGPoint)offset
{
    for (NSArray *modelArray in self.poster2ModelArrM) {
        TJPosterModel *model = modelArray[self.currentIndex];
        TJPosterModel *firstModel = self.firstPosterModelArray[self.currentIndex];
        
//        model.tj_offset = CGPointMake(model.tj_offset.x - offset.x / (Screen_Width / backWidth), model.tj_offset.y - offset.y / (Screen_Width / backWidth));
        
        
        CGFloat scale = model.tj_scale / firstModel.tj_scale;
        CGFloat angle = model.tj_angle - firstModel.tj_angle;
        
        angle += [TJ_PointConver tj_anglePoint:offset];
        
        CGFloat r = sqrt(offset.x * offset.x + offset.y * offset.y);
        
        model.tj_offset = CGPointMake(model.tj_offset.x - r / (Screen_Width / backWidth) * cos(angle), model.tj_offset.y - r / (Screen_Width / backWidth) * sin(angle));
    }
}


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



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TJ_PosterTapGestureNotification" object:nil];
}



@end
