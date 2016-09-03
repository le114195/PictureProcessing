//
//  GrammarTest.cpp
//  openCV
//
//  Created by 勒俊 on 16/8/4.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#include "GrammarTest.hpp"



void GrammarBase::virtual_test()
{
    printf("GrammarBase_virtual_test\n");
}






/*- - - - - - - - - - - - - - - - - - - - - - - -*/

void GrammmarDemo::virtual_test()
{
    printf("GrammmarDemo_virtual_test\n");
}

void GrammmarDemo::pure_virtual()
{
    xx = 234;
    printf("xx = %d\n", xx);
    printf("GrammmarDemo_pure_virtual\n");
}


void GrammmarDemo::static_test()
{
    
    printf("GrammmarDemo_static_test\n");
}



/*- - - - - - - - - - - - - - - - - - - - - - - -*/


/**
 * 第一个参数为线程执行函数
 * 第二个参数为线程回调函数
 */
void TJPthread::createThread(void *(*func)(void *), void *parameter)
{
    pthread_create(&ptid, NULL, func, parameter);
    
    pthread_join(ptid, NULL);
}


void TJPthread::pure_virtual()
{
    printf("TJPthread_pure_virtual\n");
}



