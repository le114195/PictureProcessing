//
//  GPUImageTest.h
//  openCV
//
//  Created by 勒俊 on 16/8/6.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface GPUImageTest : NSObject


//调整颜色
/*- - - - - - - - - - - -  - - - -  - - -  - - - - -  - - - -*/

/** 亮度 */
@property (nonatomic, strong) GPUImageBrightnessFilter      *brightnessFilter;

/** 曝光 */
@property (nonatomic, strong) GPUImageExposureFilter        *exposureFilter;

/** 对比度 */
@property (nonatomic, strong) GPUImageContrastFilter        *contrastFilter;

/** 饱和度 */
@property (nonatomic, strong) GPUImageSaturationFilter      *saturationFilter;

/** 褐色 */
@property (nonatomic, strong) GPUImageSepiaFilter           *sepiaFilter;

/** 伽马线 */
@property (nonatomic, strong) GPUImageGammaFilter           *gammaFilter;

/** 反色 */
@property (nonatomic, strong) GPUImageColorInvertFilter     *colorInvertFilter;

/** 色阶：待研究 */
@property (nonatomic, strong) GPUImageLevelsFilter          *levelsFilter;

/** 灰度 */
@property (nonatomic, strong) GPUImageGrayscaleFilter       *grayscaleFilter;

/** 色彩直方图，显示在图片上：待研究 */
@property (nonatomic, strong) GPUImageHistogramFilter       *histogramFilter;

/** 彩色直方图：待研究 */
@property (nonatomic, strong) GPUImageHistogramGenerator    *histogramGenerator;

/** rgb */
@property (nonatomic, strong) GPUImageRGBFilter             *rgbFilter;

/** 色调曲线：待研究 */
@property (nonatomic, strong) GPUImageToneCurveFilter       *toneCurveFilter;

/** 单色：待研究 */
@property (nonatomic, strong) GPUImageMonochromeFilter      *monochromeFilter;

/** 不透明度 */
@property (nonatomic, strong) GPUImageOpacityFilter         *opacityFilter;

/** 提亮阴影 */
@property (nonatomic, strong) GPUImageHighlightShadowFilter *highlightShadowFilter;

/** 色彩替换：待研究 */
@property (nonatomic, strong) GPUImageFalseColorFilter      *falseColorFilter;

/** 色度 */
@property (nonatomic, strong) GPUImageHueFilter             *hueFilter;

/** 色度键：待研究 */
@property (nonatomic, strong) GPUImageChromaKeyFilter       *chromaKeyFilter;

/** 白平衡：待研究 */
@property (nonatomic, strong) GPUImageWhiteBalanceFilter    *whiteBalanceFilter;

/** 像素平均值：待研究 */
@property (nonatomic, strong) GPUImageAverageColor          *averageColor;

/** 纯色：待研究 */
@property (nonatomic, strong) GPUImageSolidColorGenerator   *solidColorGenerator;

/** 亮度平均：待研究 */
@property (nonatomic, strong) GPUImageLuminosity            *luminosity;

/** 像素色值亮度平均，图像黑白（有类似漫画效果） */
@property (nonatomic, strong) GPUImageAverageLuminanceThresholdFilter       *averageLuminanceThresholdFilter;




//图像处理
/*- - - - - - - - - - - -  - - - -  - - -  - - - - -  - - - -*/


/** 十字：待研究 */
@property (nonatomic, strong) GPUImageCrosshairGenerator            *crosshairGenerator;

/** 线条 */
@property (nonatomic, strong) GPUImageLineGenerator                 *lineGenerator;

/** 高斯模糊 */
@property (nonatomic, strong) GPUImageGaussianBlurFilter            *gaussianBlurFilter;

/** 高斯模糊，选择部分清晰 */
@property (nonatomic, strong) GPUImageGaussianSelectiveBlurFilter   *gaussianSelectiveBlurFilter;

/** 盒状模糊 */
@property (nonatomic, strong) GPUImageBoxBlurFilter                 *boxBlurFilter;

/** 运动模糊 */
@property (nonatomic, strong) GPUImageMotionBlurFilter              *motionBlurFilter;

/**  */
@property (nonatomic, strong) GPUImageZoomBlurFilter                *zoomBlurFilter;

/** 双边模糊 */
@property (nonatomic, strong) GPUImageBilateralFilter               *bilateralFilter;

/** Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果) */
@property (nonatomic, strong) GPUImageSobelEdgeDetectionFilter      *sobelEdgeDetectionFilter;

/** 素描 */
@property (nonatomic, strong) GPUImageSketchFilter                  *sketchFilter;

/** 阀值素描，形成有噪点的素描 */
@property (nonatomic, strong) GPUImageThresholdSketchFilter         *thresholdSketchFilter;

/** 卡通效果（黑色粗线描边） */
@property (nonatomic, strong) GPUImageToonFilter                    *toonFilter;

/** 更细腻的卡通效果（黑色粗线描边） */
@property (nonatomic, strong) GPUImageSmoothToonFilter              *smoothToonFilter;

/** 黑白马赛克 */
@property (nonatomic, strong) GPUImageMosaicFilter                  *mosaicFilter;

/** 晕影，形成黑色圆形边缘，突出中间图像的效果 */
@property (nonatomic, strong) GPUImageVignetteFilter                *vignetteFilter;

/** 漩涡，中间形成卷曲的画面 */
@property (nonatomic, strong) GPUImageSwirlFilter                   *swirlFilter;

/** 凸起失真，鱼眼效果 */
@property (nonatomic, strong) GPUImageBulgeDistortionFilter         *bulgeDistortionFilter;


/** GPUImageChromaKeyBlendFilter */
@property (nonatomic, strong) GPUImageChromaKeyBlendFilter          *chromaKeyBlendFilter;


/** GPUImageMultiplyBlendFilter */
@property (nonatomic, strong) GPUImageMultiplyBlendFilter           *multiplyBlendFilter;


+ (instancetype)shareInstance;




@end
