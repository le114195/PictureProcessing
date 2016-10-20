//
//  ImagePicker.m
//  openCV
//
//  Created by 勒俊 on 16/9/1.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "ImagePicker.h"

@interface ImagePicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) TJCompletionBlockOne                     completion;

@property (nonatomic, strong) UIImagePickerController               *picker;

@end


@implementation ImagePicker

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

- (void)getOriginImage:(UIViewController *)vc completion:(TJCompletionBlockOne)completion
{
    [vc presentViewController:self.picker animated:YES completion:nil];
    self.completion = completion;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * imageOri = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.completion) {
        self.completion(imageOri);
    }
    [self.picker dismissViewControllerAnimated:YES completion:nil];
}


@end
