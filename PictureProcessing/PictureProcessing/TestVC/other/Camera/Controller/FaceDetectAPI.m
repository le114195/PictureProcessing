//
//  FaceDetectAPI.m
//  faceDetection
//
//  Created by 崔海港 on 2016/11/1.
//  Copyright © 2016年 Geniteam. All rights reserved.
//

#import "FaceDetectAPI.h"

@implementation FaceDetectAPI

-(struct ObjectRect)dectetFacePosition:(UIImage *)inputImage{
    struct ObjectRect faceRect = {0,0,0,0};
    
    NSLog(@"1 = %f", [[NSDate date] timeIntervalSince1970]);
    
    CIImage* tempImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    NSLog(@"2 = %f", [[NSDate date] timeIntervalSince1970]);
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey: CIDetectorAccuracy]];
    
    NSLog(@"3 = %f", [[NSDate date] timeIntervalSince1970]);
    
    NSArray* features = [detector featuresInImage:tempImage];
    
    NSLog(@"4 = %f", [[NSDate date] timeIntervalSince1970]);
    
    if(features.count > 0){
        CIFaceFeature* faceObject = features[0];
        CGRect modifiedFaceBounds = faceObject.bounds;
        modifiedFaceBounds.origin.y = inputImage.size.height-faceObject.bounds.size.height-faceObject.bounds.origin.y;
        faceRect.x = modifiedFaceBounds.origin.x;
        faceRect.y = modifiedFaceBounds.origin.x;
        faceRect.width = modifiedFaceBounds.size.width;
        faceRect.height = modifiedFaceBounds.size.height;
    }
    
    NSLog(@"5 = %f", [[NSDate date] timeIntervalSince1970]);
    
    return faceRect;
}

-(struct ObjectRect)dectetLeftEyePosition:(UIImage *)inputImage{
    struct ObjectRect leftEyeRect = {0,0,0,0};
    
    CIImage* tempImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey: CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:tempImage];
    
    if(features.count > 0){
        CIFaceFeature* faceObject = features[0];
        if (faceObject.hasLeftEyePosition){
            leftEyeRect.x = faceObject.leftEyePosition.x;
            leftEyeRect.y = inputImage.size.height - faceObject.leftEyePosition.y;
            leftEyeRect.width = 10;
            leftEyeRect.height = 10;
        }
        
    }
    
    return leftEyeRect;
}

-(struct ObjectRect)dectetRightEyePosition:(UIImage *)inputImage{
    struct ObjectRect rightEyeRect = {0,0,0,0};
    
    CIImage* tempImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey: CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:tempImage];
    
    if(features.count > 0){
        CIFaceFeature* faceObject = features[0];
        if (faceObject.hasRightEyePosition){
            rightEyeRect.x = faceObject.rightEyePosition.x;
            rightEyeRect.y = inputImage.size.height - faceObject.rightEyePosition.y;
            rightEyeRect.width = 10;
            rightEyeRect.height = 10;
        }
        
    }
    
    return rightEyeRect;
}

-(struct ObjectRect)dectetMouthPosition:(UIImage *)inputImage{
    struct ObjectRect mouthRect = {0,0,0,0};
    
    CIImage* tempImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey: CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:tempImage];
    
    if(features.count > 0){
        CIFaceFeature* faceObject = features[0];
        if (faceObject.hasMouthPosition){
            mouthRect.x = faceObject.mouthPosition.x;
            mouthRect.y = inputImage.size.height - faceObject.mouthPosition.y;
            mouthRect.width = 10;
            mouthRect.height = 10;
        }
        
    }
    
    return mouthRect;
}

@end
