//
//  UIImage+TJ.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/20.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "UIImage+TJ.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <vector>
#import "GrammarTest.hpp"

@implementation UIImage (TJ)

- (void)saveImageWithImgName:(NSString *)imgName imageType:(int)imageType
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData = nil;
    if (imageType) {
        imageData = UIImagePNGRepresentation(self);
    }else {
        imageData = UIImageJPEGRepresentation(self, 1.0);
    }
    [fileManager createFileAtPath:[NSString stringWithFormat:@"%@/%@", ToolDirectory, imgName] contents:imageData attributes:nil];
    
}

-(UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



- (void)drawAtCenter:(CGPoint)center Alpha:(CGFloat) alpha withTranslation:(CGPoint)translation radian:(CGFloat)radian scale:(CGFloat)scale {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, center.x + translation.x, center.y + translation.y);
    CGContextScaleCTM(context, scale, scale);
    CGContextRotateCTM(context, radian);
    [self drawAtCenter:CGPointZero Alpha:alpha];
    
    CGContextRestoreGState(context);
}

- (void) drawAtCenter:(CGPoint) center Alpha:(CGFloat) alpha {
    CGPoint point = CGPointMake(center.x - self.size.width / 2, center.y - self.size.height / 2);
    [self drawAtPoint:point blendMode:kCGBlendModeNormal alpha:alpha];
}


/** 左右反转图片 */
- (UIImage *)tj_reversal
{
    cv::Mat src, dst;
    UIImageToMat(self, src, 1);
    dst = cv::Mat::zeros(src.rows, src.cols, src.type());
    switch (src.channels()) {
        case 1:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<uchar>(j, src.cols - i - 1) = src.at<uchar>(j, i);
                }
            }
            break;
        }
        case 3:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec3b>(j, src.cols - i - 1)[0] = src.at<cv::Vec3b>(j, i)[0];
                    dst.at<cv::Vec3b>(j, src.cols - i - 1)[1] = src.at<cv::Vec3b>(j, i)[1];
                    dst.at<cv::Vec3b>(j, src.cols - i - 1)[2] = src.at<cv::Vec3b>(j, i)[2];
                }
            }
            break;
        }
        case 4:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec4b>(j, src.cols - i - 1)[0] = src.at<cv::Vec4b>(j, i)[0];
                    dst.at<cv::Vec4b>(j, src.cols - i - 1)[1] = src.at<cv::Vec4b>(j, i)[1];
                    dst.at<cv::Vec4b>(j, src.cols - i - 1)[2] = src.at<cv::Vec4b>(j, i)[2];
                    dst.at<cv::Vec4b>(j, src.cols - i - 1)[3] = src.at<cv::Vec4b>(j, i)[3];
                }
            }
            break;
        }
        default:
            break;
    }
    return MatToUIImage(dst);
}


/** 上下反转图片 */
- (UIImage *)tj_invert
{
    cv::Mat src, dst;
    UIImageToMat(self, src, 1);
    dst = cv::Mat::zeros(src.rows, src.cols, src.type());
    switch (src.channels()) {
        case 1:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<uchar>(src.rows - j - 1, i) = src.at<uchar>(j, i);
                }
            }
            break;
        }
        case 3:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec3b>(src.rows - j - 1, i)[0] = src.at<cv::Vec3b>(j, i)[0];
                    dst.at<cv::Vec3b>(src.rows - j - 1, i)[1] = src.at<cv::Vec3b>(j, i)[1];
                    dst.at<cv::Vec3b>(src.rows - j - 1, i)[2] = src.at<cv::Vec3b>(j, i)[2];
                }
            }
            break;
        }
        case 4:{
            for (int i = 0; i < src.cols; i++) {
                for (int j = 0; j < src.rows; j++) {
                    dst.at<cv::Vec4b>(src.rows - j - 1, i)[0] = src.at<cv::Vec4b>(j, i)[0];
                    dst.at<cv::Vec4b>(src.rows - j - 1, i)[1] = src.at<cv::Vec4b>(j, i)[1];
                    dst.at<cv::Vec4b>(src.rows - j - 1, i)[2] = src.at<cv::Vec4b>(j, i)[2];
                    dst.at<cv::Vec4b>(src.rows - j - 1, i)[3] = src.at<cv::Vec4b>(j, i)[3];
                }
            }
            break;
        }
        default:
            break;
    }
    return MatToUIImage(dst);
}





@end
