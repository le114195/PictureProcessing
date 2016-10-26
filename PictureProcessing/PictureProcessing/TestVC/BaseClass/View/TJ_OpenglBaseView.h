//
//  TJ_OpenglBaseView.h
//  PictureProcessing
//
//  Created by 勒俊 on 2016/10/25.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface TJ_OpenglBaseView : UIView
{
    NSString *VertexShaderString;
    NSString *FragmentShaderString;
}

@property (nonatomic, strong) UIImage           *originImg;
@property (nonatomic, strong) UIImage           *renderImg;

@property (nonatomic , strong) EAGLContext      *myContext;
@property (nonatomic , strong) CAEAGLLayer      *myEagLayer;
@property (nonatomic , assign) GLuint           myProgram;
@property (nonatomic , assign) GLuint           myVertices;

@property (nonatomic , assign) GLuint           myColorRenderBuffer;
@property (nonatomic , assign) GLuint           myColorFrameBuffer;

@property (nonatomic, assign) CGFloat           ImgWidth;
@property (nonatomic, assign) CGFloat           ImgHeight;



- (void)destoryRenderAndFrameBuffer;

- (void)setupLayer;

- (void)setupContext;

- (void)setupRenderBuffer;

- (void)setupFrameBuffer;

- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag;


@end
