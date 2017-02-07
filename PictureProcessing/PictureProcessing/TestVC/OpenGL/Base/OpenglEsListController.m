//
//  OpenglEsListController.m
//  PictureProcessing
//
//  Created by 勒俊 on 2017/2/7.
//  Copyright © 2017年 勒俊. All rights reserved.
//

#import "OpenglEsListController.h"
#import "TestCell.h"
#import "TextureListerController.h"
#import "BrushListController.h"
#import "CurveListController.h"
#import "OpenGL3DListerController.h"

@interface OpenglEsListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView         *tableView;
@property (nonatomic, strong) NSArray           *dataArray;

@end

@implementation OpenglEsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.dataArray = @[@"OpenGL纹理", @"画笔", @"扭曲", @"3D"];
    
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
        case 0:{
            TextureListerController *textureList = [[TextureListerController alloc] init];
            [self.navigationController pushViewController:textureList animated:YES];
            break;
        }
        case 1:{
            BrushListController *brushVC = [[BrushListController alloc] init];
            [self.navigationController pushViewController:brushVC animated:YES];
            break;
        }
        case 2:{
            CurveListController *curveVC = [[CurveListController alloc] init];
            [self.navigationController pushViewController:curveVC animated:YES];
            break;
        }
        case 3:{
            OpenGL3DListerController *opengl3D = [[OpenGL3DListerController alloc] init];
            [self.navigationController pushViewController:opengl3D animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
