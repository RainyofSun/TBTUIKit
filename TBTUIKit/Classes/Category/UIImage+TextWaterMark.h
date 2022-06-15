//
//  UIImage+TextWater.h
//  Nicelive
//
//  Created by 张守敏 on 15/3/23.
//  Copyright (c) 2015年 Nice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TextWaterMark)
/**
 *  给图片添加文字水印
 *
 *  @param text1     水印文字
 *  @param img       图片
 *  @param textFont  文字字体大小
 *  @param textColor 文字颜色
 *  @param textTop   文字距离图片顶部距离 默认41
 *  @param textLeft  文字距离图片左边的距离 默认最小为6
 *
 */
+ (UIImage *)addTextWaterMark:(NSString *)text1 inImage:(UIImage *)img textFont:(CGFloat)textFont textColor:(UIColor*)textColor textTop:(CGFloat)textTop textLeft:(CGFloat)textLeft;

@end
