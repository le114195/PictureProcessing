//
//  TJOpenglesCurve.m
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/13.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "TJOpenglesCurve.h"
#import <GLKit/GLKit.h>


NSString *const TJ_Text2D1VertexShaderString = TJ_STRING_ES
(
 attribute vec4 position;
 attribute vec2 textCoordinate;
 
 uniform mat4 projectionMatrix;
 uniform mat4 modelViewMatrix;
 
 varying lowp vec2 varyTextCoord;
 
 void main()
{
    varyTextCoord = textCoordinate;
    gl_Position = position;
}
 );


NSString *const TJ_Text2D1FragmentShaderString = TJ_STRING_ES
(
 
 varying lowp vec2 varyTextCoord;
 
 uniform sampler2D colorMap;
 
 void main()
 {
     highp vec2 textureCoordinateToUse = varyTextCoord;
     
     if (textureCoordinateToUse.x < 0.1 && textureCoordinateToUse.y < 0.1){
         gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
     }else {
         gl_FragColor = texture2D(colorMap, textureCoordinateToUse);
     }
 }
 
 
 );






@implementation TJOpenglesCurve







@end
