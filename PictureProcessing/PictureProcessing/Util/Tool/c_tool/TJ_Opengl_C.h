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



typedef struct{

    double x;
    double y;
} TJ_GLPoint;

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


/** 眨眼睛算法
 *  attrArr：保存顶点坐标的数组
 *  rectLength：attrArr数组的长度
 *  ImgWidth：待处理图像的宽度
 *  ImgHeight：待处理图像的高度
 *  eye_top：眼睛的顶部
 *  eye_bottom：眼睛的底部
 *  eye_left_corner：眼睛的最左边
 *  eye_right_corner：眼睛的最右边
 */
void tj_curve_eye(GLfloat *attrArr, GLuint rectLength, double ImgWidth, double ImgHeight, TJ_GLPoint eye_top, TJ_GLPoint eye_bottom, TJ_GLPoint eye_left_corner, TJ_GLPoint eye_right_corner);





void tj_curve_eyebrow(GLfloat *attrArr, GLuint rectLength, double ImgWidth, double ImgHeight, TJ_GLPoint eye_top, TJ_GLPoint eyebrow_upper_middle, TJ_GLPoint eyebrow_lower_middle, TJ_GLPoint eyebrow_left_corner, TJ_GLPoint eyebrow_right_corner);







#endif /* TJ_Opengl_C_h */
