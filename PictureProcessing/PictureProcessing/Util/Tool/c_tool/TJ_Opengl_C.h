//
//  TJ_Opengl_C.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef TJ_Opengl_C_h
#define TJ_Opengl_C_h

#include <stdio.h>
#include <OpenGLES/gltypes.h>


/** 将一个二维图片用三角面片表示
 *  attrArr：表示三角面片中的所有的点 
 *  rectW：表示一行有多少个点
 *  rectH：表示一列有多少个点
 */
void configure_attrArr(GLfloat *attrArr, GLint rectW, GLint rectH);


/** 初始化三角形点所在的位置
 *  indices：三角形点所在的位置
 *  rectW：表示一行有多少个点
 *  rectH：表示一列有多少个点
 */
void configure_indices(GLint *indices, GLint rectW, GLint rectH);



#endif /* TJ_Opengl_C_h */
