//
//  CoreImageList.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/16.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "CoreImageList.h"
#import "TestCell.h"
#import "CoreImageVCTest.h"
#import "CorePara.h"


@interface CoreImageList ()<UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, weak) UITableView         *tableView;

@property (nonatomic, strong) NSArray           *dataArray;


@end

@implementation CoreImageList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.dataArray = @[@"CIBoxBlur", @"CIDiscBlur", @"CIGaussianBlur", @"CIMotionBlur", @"CINoiseReduction", @"CIZoomBlur", @"CIColorControls"];
    
    [self tableViewConfigure];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


#pragma mark - 子控件初始化


- (void)tableViewConfigure
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[TestCell class] forCellReuseIdentifier:@"TestCell"];
}




#pragma mark - 数据初始化






#pragma mark - set/get





#pragma mark - 点击事件






#pragma mark - 代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.dataArray) {
        return 0;
    }else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *parameters;
    
    switch (indexPath.row) {
        case 0:{//CIBoxBlur
            parameters = [CorePara boxBlur];
            break;
        }
        case 1:{//CIDiscBlur
            parameters = [CorePara discBlur];
            break;
        }
        case 2:{//CIGaussianBlur
            parameters = [CorePara gaussianBlur];
            break;
        }
        case 3:{//CIMotionBlur
            parameters = [CorePara motionBlur];
            break;
        }
        case 4:{//CINoiseReduction
            parameters = [CorePara noiseReduction];
            break;
        }
        case 5:{//CIZoomBlur
            parameters = [CorePara zoomBlur];
            break;
        }
        case 6:{//CIColorControls
            parameters = [CorePara colorControls];
            break;
        }
        default:
            break;
    }
    CoreImageVCTest *coreVC = [[CoreImageVCTest alloc] init];
    coreVC.parameters = parameters;
    [self.navigationController pushViewController:coreVC animated:YES];
}



#pragma mark - 私有方法






@end