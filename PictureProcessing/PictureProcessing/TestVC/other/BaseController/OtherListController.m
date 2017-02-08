//
//  OtherListController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/8.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OtherListController.h"
#import "TestCell.h"


#import "TxtController.h"
#import "ScrollViewGestureVC.h"


@interface OtherListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView         *tableView;
@property (nonatomic, strong) NSArray           *dataArray;

@end

@implementation OtherListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dataArray = @[@"文字", @"ScrollView手势"];
    
    [self tableViewConfigure];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableViewConfigure
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[TestCell class] forCellReuseIdentifier:@"TestCell"];
}



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
        case 0:
            [self txtDemo];
            break;
        case 1:
            [self scrollerViewGesture];
            break;
            
        default:
            break;
    }
}




/** 文字测试 */
- (void)txtDemo
{
    TxtController *txtVC = [[TxtController alloc] init];
    [self.navigationController pushViewController:txtVC animated:YES];
}

/** ScrollerViewGesture */
- (void)scrollerViewGesture
{
    ScrollViewGestureVC *scrollViewVC = [[ScrollViewGestureVC alloc] init];
    [self.navigationController pushViewController:scrollViewVC animated:YES];
}




@end
