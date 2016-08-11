//
//  ViewController.m
//  PictureProcessing
//
//  Created by 勒俊 on 16/8/11.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "ViewController.h"
#import "TestCell.h"
#import "OpencvTestVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, weak) UITableView         *tableView;

@property (nonatomic, strong) NSArray           *dataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArray = @[@"opencvTest"];
    
    [self tableViewConfigure];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 子控件初始化


- (void)tableViewConfigure
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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
    
    switch (indexPath.row) {
        case 0:{
            
            OpencvTestVC *opencv = [[OpencvTestVC alloc] init];
            
            [self.navigationController pushViewController:opencv animated:YES];
            break;
        }
            
        case 1:{
            
            
            break;
        }
            
        default:
            break;
    }
    
}



#pragma mark - 私有方法







@end
