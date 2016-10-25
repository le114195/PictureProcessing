//
//  TJ_Opengl_C.c
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "TJ_Opengl_C.h"



void configure_attrArr(GLfloat *attrArr, GLint rectW, GLint rectH)
{
    GLfloat rateX = 2.0/(rectW - 1);
    GLfloat rateY = 2.0/(rectH - 1);
    for (int i = 0; i < rectW * rectH; i++) {
        attrArr[i * 5] = -1 + rateX * (i%rectW);
        attrArr[i * 5 + 1] = 1 - (i/rectW) * rateY;
        attrArr[i * 5 + 2] = 0;
        attrArr[i * 5 + 3] = (i%rectW) * rateX * 0.5;
        attrArr[i * 5 + 4] = (i/rectW) * rateY * 0.5;
    }
}

void configure_indices(GLint *indices, GLint rectW, GLint rectH)
{
    for (int i = 0; i < (rectW - 1) * (rectH - 1); i++) {
        indices[i * 6] = i / (rectW - 1) * rectW + i%(rectW - 1);
        indices[i * 6 + 1] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1);
        indices[i * 6 + 2] = i / (rectW - 1) * rectW + rectW +  + i%(rectW - 1) + 1;
        
        indices[i * 6 + 3] = i / (rectW - 1) * rectW + i%(rectW - 1);
        indices[i * 6 + 4] = i / (rectW - 1) * rectW + i%(rectW - 1) + 1;
        indices[i * 6 + 5] = i / (rectW - 1) * rectW + rectW + i%(rectW - 1) + 1;
    }
}






