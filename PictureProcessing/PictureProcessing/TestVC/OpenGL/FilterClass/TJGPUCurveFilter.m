//
//  TJGPUCurveFilter.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/14.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJGPUCurveFilter.h"



#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const TJCurveFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform highp float aspectRatio;

 
 void main()
 {
     highp vec2 center = vec2(0.5, 0.5);
     highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y - center.y) * aspectRatio + center.y);
     highp float dist = distance(center, textureCoordinateToUse);
     
     if (dist < 0.2){
         textureCoordinateToUse = vec2(textureCoordinateToUse.x + (0.2 - dist) * (0.2 - dist), textureCoordinateToUse.y);
         gl_FragColor = texture2D(inputImageTexture, textureCoordinateToUse);
     }else {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
 }
 );
#else
NSString *const TJCurveFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform float aspectRatio;
 
 void main()
 {
     highp vec2 center = vec2(0.5, 0.5);
     highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y - center.y) * aspectRatio + center.y);
     highp float dist = distance(center, textureCoordinateToUse);
     
     if (dist < 0.2){
         textureCoordinateToUse = vec2(textureCoordinateToUse.x + (0.2 - dist) * (0.2 - dist), textureCoordinateToUse.y);
         gl_FragColor = texture2D(inputImageTexture, textureCoordinateToUse);
     }else {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
 }
 );
#endif


@implementation TJGPUCurveFilter
{
    GLuint      aspectRatioUniform;
}

- (instancetype)init
{
    if (!(self = [super initWithFragmentShaderFromString:TJCurveFragmentShaderString]))
    {
        return nil;
    }
    
    aspectRatioUniform = [filterProgram uniformIndex:@"aspectRatio"];
    
    
    return self;
}





@end
