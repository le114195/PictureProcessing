//
//  GrammarTest.hpp
//  openCV
//
//  Created by 勒俊 on 16/8/4.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#ifndef GrammarTest_hpp
#define GrammarTest_hpp

#include <stdio.h>
#include <pthread.h>
#include <vector>

using namespace std;

#endif /* GrammarTest_hpp */


class GrammarBase {

    
public:
    virtual void pure_virtual() = 0;//纯虚函数:父类不用实现，但子类必须实现
    
    virtual void virtual_test();//虚函数：父类需要实现，子类可以选择覆盖父类的实现
    
    
protected:
    
    
    
private:
    
    
    
    
};


/*- - - - - - - - - - - - - - - - - - - - - - - - - - - */

class GrammmarDemo:public GrammarBase {
    
    
public:
    
    int xx;
    
    static void static_test();
    
    virtual void pure_virtual();//实现父类的纯虚函数
    
    virtual void virtual_test();//覆盖父类的虚函数
    
    
    void vecTest(int x);
    
    
protected:
    
    
    
private:
    
    vector<int> tt;
    
    
};


/*- - - - - - - - - - - - - - - - - - - - - - - - - - - */

class TJPthread: public GrammarBase {
    
public:
    typedef void (*PushBack)(int x, int y);
    pthread_t ptid;
    
    void createThread(void*(*func)(void *), void *parameter);
    
    virtual void pure_virtual();//实现父类的纯虚函数
    
};





