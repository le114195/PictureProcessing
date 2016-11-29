//
//  TJGIFListController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/11/29.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJGIFListController.h"
#import "TestCell.h"
#import "TJGIFController.h"

@interface TJGIFListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray           *dataArray;
@property (nonatomic, weak) UITableView         *tableView;

@end

@implementation TJGIFListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArray = @[@"hahac400010m400010", @"gifExpression3", @"gifExpression4"];
    
    
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
    NSString *xmlTitle = self.dataArray[indexPath.row];
    TJGIFController *gifVC = [TJGIFController gifWithTitle:xmlTitle];
    [self.navigationController pushViewController:gifVC animated:YES];
}



@end
