//
//  GPUImageTest.m
//  openCV
//
//  Created by 勒俊 on 16/8/6.
//  Copyright © 2016年 勒俊. All rights reserved.
//

#import "GPUImageTest.h"

@implementation GPUImageTest









#pragma mark - 颜色调整



/** 亮度 */
- (GPUImageBrightnessFilter *)brightnessFilter
{
    if (!_brightnessFilter) {
        _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        _brightnessFilter.brightness = 0;
    }
    return _brightnessFilter;
}

/** 曝光 */
- (GPUImageExposureFilter *)exposureFilter
{
    if (!_exposureFilter) {
        _exposureFilter = [[GPUImageExposureFilter alloc] init];
        _exposureFilter.exposure = 0;
    }
    return _exposureFilter;
}


/** 对比度 */
- (GPUImageContrastFilter *)contrastFilter
{
    if (!_contrastFilter) {
        _contrastFilter = [[GPUImageContrastFilter alloc] init];
        _contrastFilter.contrast = 1.0;
    }
    return _contrastFilter;
}


/** 饱和度 */
- (GPUImageSaturationFilter *)saturationFilter
{
    if (!_saturationFilter) {
        _saturationFilter = [[GPUImageSaturationFilter alloc] init];
        _saturationFilter.saturation = 1.0;
    }
    return _saturationFilter;
}


/** 褐色 */
- (GPUImageSepiaFilter *)sepiaFilter
{
    if (!_sepiaFilter) {
        _sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    }
    return _sepiaFilter;
}

/** 伽马线 */
- (GPUImageGammaFilter *)gammaFilter
{
    if (!_gammaFilter) {
        _gammaFilter = [[GPUImageGammaFilter alloc] init];
        _gammaFilter.gamma = 1.0;
    }
    return _gammaFilter;
}


/** 反色 */
- (GPUImageColorInvertFilter *)colorInvertFilter
{
    if (!_colorInvertFilter) {
        _colorInvertFilter = [[GPUImageColorInvertFilter alloc] init];
    }
    return _colorInvertFilter;
}


/** 色阶：需要研究 */
- (GPUImageLevelsFilter *)levelsFilter
{
    if (!_levelsFilter) {
        _levelsFilter = [[GPUImageLevelsFilter alloc] init];
    }
    return _levelsFilter;
}


/** 灰度 */
- (GPUImageGrayscaleFilter *)grayscaleFilter
{
    if (!_grayscaleFilter) {
        _grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    }
    return _grayscaleFilter;
}


/** 色彩直方图，显示在图片上：待研究 */
- (GPUImageHistogramFilter *)histogramFilter
{
    if (!_histogramFilter) {
        _histogramFilter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRed];
    }
    return _histogramFilter;
}


/** 彩色直方图：待研究 */
- (GPUImageHistogramGenerator *)histogramGenerator
{
    if (!_histogramGenerator) {
        _histogramGenerator = [[GPUImageHistogramGenerator alloc] init];
    }
    return _histogramGenerator;
}


/** rgb */
- (GPUImageRGBFilter *)rgbFilter
{
    if (!_rgbFilter) {
        _rgbFilter = [[GPUImageRGBFilter alloc] init];
    }
    return _rgbFilter;
}


/** 色调曲线：待研究 */
- (GPUImageToneCurveFilter *)toneCurveFilter
{
    if (!_toneCurveFilter) {
        _toneCurveFilter = [[GPUImageToneCurveFilter alloc] init];
    }
    return _toneCurveFilter;
}


/** 单色：待研究 */
- (GPUImageMonochromeFilter *)monochromeFilter
{
    if (!_monochromeFilter) {
        _monochromeFilter = [[GPUImageMonochromeFilter alloc] init];
    }
    return _monochromeFilter;
}


/** 不透明度 */
- (GPUImageOpacityFilter *)opacityFilter
{
    if (!_opacityFilter) {
        _opacityFilter = [[GPUImageOpacityFilter alloc] init];
        _opacityFilter.opacity = 1.0;
    }
    return _opacityFilter;
}


/** 提亮阴影 */
- (GPUImageHighlightShadowFilter *)highlightShadowFilter
{
    if (!_highlightShadowFilter) {
        _highlightShadowFilter = [[GPUImageHighlightShadowFilter alloc] init];
        _highlightShadowFilter.shadows = 1;
        _highlightShadowFilter.highlights = 1;
    }
    return _highlightShadowFilter;
}



/** 色彩替换：待研究 */
- (GPUImageFalseColorFilter *)falseColorFilter
{
    if (!_falseColorFilter) {
        _falseColorFilter = [[GPUImageFalseColorFilter alloc] init];
    }
    return _falseColorFilter;
}


/** 色度 */
- (GPUImageHueFilter *)hueFilter
{
    if (!_hueFilter) {
        _hueFilter = [[GPUImageHueFilter alloc] init];
    }
    
    return _hueFilter;
}


/** 色度键：待研究 */
- (GPUImageChromaKeyFilter *)chromaKeyFilter
{
    if (!_chromaKeyFilter) {
        _chromaKeyFilter = [[GPUImageChromaKeyFilter alloc] init];
    }
    return _chromaKeyFilter;
}



/** 白平衡：待研究 */
- (GPUImageWhiteBalanceFilter *)whiteBalanceFilter
{
    if (!_whiteBalanceFilter) {
        _whiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    }
    return _whiteBalanceFilter;
}



/** 像素平均值：待研究 */
- (GPUImageAverageColor *)averageColor
{
    if (!_averageColor) {
        _averageColor = [[GPUImageAverageColor alloc] init];
    }
    return _averageColor;
}



/** 纯色：待研究 */
- (GPUImageSolidColorGenerator *)solidColorGenerator
{
    if (!_solidColorGenerator) {
        _solidColorGenerator = [[GPUImageSolidColorGenerator alloc] init];
    }
    return _solidColorGenerator;
}


/** 亮度平均：待研究 */
- (GPUImageLuminosity *)luminosity
{
    if (!_luminosity) {
        _luminosity = [[GPUImageLuminosity alloc] init];
    }
    return _luminosity;
}


/** 像素色值亮度平均，图像黑白（有类似漫画效果） */
- (GPUImageAverageLuminanceThresholdFilter *)averageLuminanceThresholdFilter
{
    if (!_averageLuminanceThresholdFilter) {
        _averageLuminanceThresholdFilter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
    }
    return _averageLuminanceThresholdFilter;
}




#pragma mark - 图像处理


/** 十字：待研究 */
- (GPUImageCrosshairGenerator *)crosshairGenerator
{
    if (!_crosshairGenerator) {
        _crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
    }
    return _crosshairGenerator;
}


/** 线条 */
- (GPUImageLineGenerator *)lineGenerator
{
    if (!_lineGenerator) {
        _lineGenerator = [[GPUImageLineGenerator alloc] init];
    }
    return _lineGenerator;
}



/** 高斯模糊 */
- (GPUImageGaussianBlurFilter *)gaussianBlurFilter
{
    if (!_gaussianBlurFilter) {
        _gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    }
    return _gaussianBlurFilter;
}


/** 高斯模糊，选择部分清晰 */
- (GPUImageGaussianSelectiveBlurFilter *)gaussianSelectiveBlurFilter
{
    if (!_gaussianSelectiveBlurFilter) {
        _gaussianSelectiveBlurFilter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
        _gaussianSelectiveBlurFilter.blurRadiusInPixels = 10.0;
        _gaussianSelectiveBlurFilter.excludeCircleRadius = 60 / 320.0;
    }
    return _gaussianSelectiveBlurFilter;
}


/** 盒状模糊 */
- (GPUImageBoxBlurFilter *)boxBlurFilter
{
    if (!_boxBlurFilter) {
        _boxBlurFilter = [[GPUImageBoxBlurFilter alloc] init];
    }
    return _boxBlurFilter;
}

/** 运动模糊 */
- (GPUImageMotionBlurFilter *)motionBlurFilter
{
    if (!_motionBlurFilter) {
        _motionBlurFilter = [[GPUImageMotionBlurFilter alloc] init];
    }
    return _motionBlurFilter;
}


- (GPUImageZoomBlurFilter *)zoomBlurFilter
{
    if (_zoomBlurFilter) {
        _zoomBlurFilter = [[GPUImageZoomBlurFilter alloc] init];
    }
    return _zoomBlurFilter;
}


/** 双边模糊 */
- (GPUImageBilateralFilter *)bilateralFilter
{
    if (!_bilateralFilter) {
        _bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    }
    return _bilateralFilter;
}



/** Sobel边缘检测算法(白边，黑内容，有点漫画的反色效果) */
- (GPUImageSobelEdgeDetectionFilter *)sobelEdgeDetectionFilter
{
    if (!_sobelEdgeDetectionFilter) {
        _sobelEdgeDetectionFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    }
    return _sobelEdgeDetectionFilter;
}


/** 素描 */
- (GPUImageSketchFilter *)sketchFilter
{
    if (!_sketchFilter) {
        _sketchFilter = [[GPUImageSketchFilter alloc] init];
    }
    return _sketchFilter;
}


/** 阀值素描，形成有噪点的素描 */
- (GPUImageThresholdSketchFilter *)thresholdSketchFilter
{
    if (!_thresholdSketchFilter) {
        _thresholdSketchFilter = [[GPUImageThresholdSketchFilter alloc] init];
    }
    return _thresholdSketchFilter;
}


/** 卡通效果（黑色粗线描边） */
- (GPUImageToonFilter *)toonFilter
{
    if (!_toonFilter) {
        _toonFilter = [[GPUImageToonFilter alloc] init];
    }
    return _toonFilter;
}


/** 更细腻的卡通效果 */
- (GPUImageSmoothToonFilter *)smoothToonFilter
{
    if (!_smoothToonFilter) {
        _smoothToonFilter = [[GPUImageSmoothToonFilter alloc] init];
    }
    return _smoothToonFilter;
}


/** 黑白马赛克 */
- (GPUImageMosaicFilter *)mosaicFilter
{
    if (!_mosaicFilter) {
        _mosaicFilter = [[GPUImageMosaicFilter alloc] init];
        _mosaicFilter.inputTileSize = CGSizeMake(100, 100);
    }
    return _mosaicFilter;
}



/** 晕影，形成黑色圆形边缘，突出中间图像的效果 */
- (GPUImageVignetteFilter *)vignetteFilter
{
    if (!_vignetteFilter) {
        _vignetteFilter = [[GPUImageVignetteFilter alloc] init];
        
        
    }
    
    return _vignetteFilter;
}



/** 漩涡，中间形成卷曲的画面 */
-(GPUImageSwirlFilter *)swirlFilter
{
    if (!_swirlFilter) {
        _swirlFilter = [[GPUImageSwirlFilter alloc] init];
    }
    return _swirlFilter;
}













#pragma mark - 单利实现

+ (instancetype)shareInstance
{
    static GPUImageTest *gpu;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gpu = [[super allocWithZone:NULL] init];
    });
    
    
    return gpu;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [GPUImageTest shareInstance];
}






@end
