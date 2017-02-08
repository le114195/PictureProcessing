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
#import "GPUImageTestVC.h"
#import "ImagePicker.h"

#import "TJ_CameraController.h"
#import "GPUVideoCameraController.h"

#import "TJMoreLayerController.h"

#import "MarchineLearingVC.h"

#import "OpenglEsListController.h"

#import "OtherListController.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ImagePicker       *imgPicker;

@property (nonatomic, weak) UITableView         *tableView;
@property (nonatomic, strong) NSArray           *dataArray;

@property (nonatomic, strong) UIImagePickerController           *picker;

@property (nonatomic, copy) void(^getImageBlock)(UIImage *image);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[@"opencvTest", @"GPUImageTest", @"OpenGL", @"自定义相机", @"gpu相机", @"图层", @"openCV机器学习", @"其他"];
    
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

- (ImagePicker *)imgPicker
{
    if (!_imgPicker) {
        _imgPicker = [[ImagePicker alloc] init];
    }
    return _imgPicker;
}


- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.delegate = self;
        _picker.allowsEditing = NO;
    }
    return _picker;
}
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
        case 0:{//OpenCVTest
            OpencvTestVC *opencv = [[OpencvTestVC alloc] init];
            [self.navigationController pushViewController:opencv animated:YES];
            break;
        }
        case 1:{
            GPUImageTestVC *gpuVC = [[GPUImageTestVC alloc] init];
            [self.navigationController pushViewController:gpuVC animated:YES];
            break;
        }
        case 2:{
            OpenglEsListController *openglVC = [[OpenglEsListController alloc] init];
            [self.navigationController pushViewController:openglVC animated:YES];
            break;
        }
        case 3:{
            TJ_CameraController *cameraVC = [[TJ_CameraController alloc] init];
            [self.navigationController pushViewController:cameraVC animated:YES];
            break;
        }
        case 4:{
            GPUVideoCameraController *gpuVC = [[GPUVideoCameraController alloc] init];
            [self.navigationController pushViewController:gpuVC animated:YES];
            break;
        }
        case 5:{
            TJMoreLayerController *layerVC = [[TJMoreLayerController alloc] init];
            [self.navigationController pushViewController:layerVC animated:YES];
        
            break;
        }
        case 6:{
            MarchineLearingVC *mlVC = [[MarchineLearingVC alloc] init];
            [self.navigationController pushViewController:mlVC animated:YES];
            break;
        }
        case 7:{
            OtherListController *otherListVC = [[OtherListController alloc] init];
            [self.navigationController pushViewController:otherListVC animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 私有方法


/** ios自带相册代理方法 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * imageOri = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.getImageBlock) {
        self.getImageBlock(imageOri);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}





@end
