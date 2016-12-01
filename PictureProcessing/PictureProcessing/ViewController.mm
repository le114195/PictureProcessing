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
#import "TJOpenGLContrtoller.h"
#import "TJOpenglCurveVC.h"
#import "TJOpenglBrushVC.h"
#import "ImagePicker.h"

#import "FaceDetectVC.h"

#import "TJGIFController.h"
#import "TJ_CameraController.h"
#import "GPUVideoCameraController.h"

#import "TJ_BlurController.h"


#import "TJMoreLayerController.h"
#import "TJ_CacheController.h"

#import "ImgTOVideoVC.h"
#import "TJGIFListController.h"



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
    
    self.dataArray = @[@"opencvTest", @"GPUImageTest", @"OpenGL", @"扭曲", @"画笔", @"人脸识别", @"gif图片", @"眨眼睛", @"挑眉毛", @"自定义相机", @"gpu相机", @"双边滤波", @"图层", @"缓存", @"图片转视频"];
    
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
    __weak __typeof(self)weakSelf = self;
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
            TJOpenGLContrtoller *openglEsVC = [[TJOpenGLContrtoller alloc] init];
            [self.navigationController pushViewController:openglEsVC animated:YES];
            break;
        }
        case 3:{
            TJOpenglCurveVC *curveVC = [TJOpenglCurveVC curveWithType:0];
            [self.navigationController pushViewController:curveVC animated:YES];
            break;
        }
        case 4:{
            TJOpenglBrushVC *brushVC = [[TJOpenglBrushVC alloc] init];
            [self.navigationController pushViewController:brushVC animated:YES];
            break;
        }
        case 5:{
            FaceDetectVC *faceVC = [[FaceDetectVC alloc] init];;
            [weakSelf.navigationController pushViewController:faceVC animated:YES];
            break;
        }
        case 6:{
            
            [self presentViewController:self.picker animated:YES completion:nil];
            __weak __typeof(self)weakSelf = self;
            self.getImageBlock = ^(UIImage *image){
                TJGIFListController *listVC = [TJGIFListController listImg:image];
                [weakSelf.navigationController pushViewController:listVC animated:YES];
            };
            break;
        }
        case 7:{
            TJOpenglCurveVC *curveVC = [TJOpenglCurveVC curveWithType:1];
            [self.navigationController pushViewController:curveVC animated:YES];
            break;
        }
        case 8:{
            TJOpenglCurveVC *curveVC = [TJOpenglCurveVC curveWithType:2];
            [self.navigationController pushViewController:curveVC animated:YES];
            
            break;
        }
        case 9:{
            TJ_CameraController *cameraVC = [[TJ_CameraController alloc] init];
            [self.navigationController pushViewController:cameraVC animated:YES];
            break;
        }
        case 10:{
            
            GPUVideoCameraController *gpuVC = [[GPUVideoCameraController alloc] init];
            [self.navigationController pushViewController:gpuVC animated:YES];
            break;
        }
            
        case 11:{
            TJ_BlurController *BTest = [[TJ_BlurController alloc] init];
            [self.navigationController pushViewController:BTest animated:YES];
            break;
        }
            
        case 12:{
            TJMoreLayerController *layerVC = [[TJMoreLayerController alloc] init];
            [self.navigationController pushViewController:layerVC animated:YES];
        
            break;
        }
        case 13:{
            TJ_CacheController *cahceVC = [[TJ_CacheController alloc] init];
            [self.navigationController pushViewController:cahceVC animated:YES];
            break;
        }
        case 14:{
            ImgTOVideoVC *ivVC = [[ImgTOVideoVC alloc] init];
            [self.navigationController pushViewController:ivVC animated:YES];
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
