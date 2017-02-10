//
//  BrushListController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "BrushListController.h"
#import "TestCell.h"
#import "BrushBaseController.h"

@interface BrushListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView         *tableView;
@property (nonatomic, strong) NSArray           *dataArray;

@end

@implementation BrushListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dataArray = @[@"画笔1", @"画笔2", @"画笔3", @"画线1"];
    
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
    BrushBaseController *openglVC = [BrushBaseController openglesVCWithIndex:indexPath.row];
    [self.navigationController pushViewController:openglVC animated:YES];
}



@end
