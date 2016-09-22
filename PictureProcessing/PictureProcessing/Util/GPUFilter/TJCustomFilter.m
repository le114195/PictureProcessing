//
//  TJCustomFilter.m
//  TJSocialNew
//
//  Created by 勒俊 on 16/9/22.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJCustomFilter.h"


NSString *const CustomFragmentShader = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
{
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 outputColor;
    outputColor.r = (textureColor.r * 0.393) + (textureColor.g * 0.769) + (textureColor.b * 0.189);
    outputColor.g = (textureColor.r * 0.349) + (textureColor.g * 0.686) + (textureColor.b * 0.168);
    outputColor.b = (textureColor.r * 0.272) + (textureColor.g * 0.534) + (textureColor.b * 0.131);
    outputColor.a = 1.0;
    
    gl_FragColor = outputColor;
}
);



@implementation TJCustomFilter


- (instancetype)init
{
    if (![super initWithFragmentShaderFromString:CustomFragmentShader]) {
        return nil;
    }
    return self;;
}



@end
