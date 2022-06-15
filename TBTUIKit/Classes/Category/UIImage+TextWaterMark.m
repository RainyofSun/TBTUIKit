//
//  UIImage+TextWater.m
//  Nicelive
//
//  Created by 张守敏 on 15/3/23.
//  Copyright (c) 2015年 Nice. All rights reserved.
//

#import "UIImage+TextWaterMark.h"
#import "NSString+Size.h"

@implementation UIImage (TextWaterMark)

+ (UIImage *)addTextWaterMark:(NSString *)text1 inImage:(UIImage *)img textFont:(CGFloat)textFont textColor:(UIColor*)textColor textTop:(CGFloat)textTop textLeft:(CGFloat)textLeft
{
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    [textColor set];
    
    //设置ID  文字的缩放比例
    CGFloat waterScale = (img.size.width/750);
    waterScale = (waterScale > 1.0)? waterScale : 1.0;
    
    textFont = textFont *waterScale;
    UIFont *font = [UIFont boldSystemFontOfSize:textFont];
    CGSize strSize = [text1 tbt_sizeWithFont:font];//41 6

    CGFloat top = 41;
    CGFloat left = 6;
    if (textLeft > 6) {
        left = textLeft;
    }
    if (textTop) {
        top = textTop;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(1.5, 1.5), 2.0, [[UIColor blackColor] colorWithAlphaComponent:.3].CGColor);
    
   
    
    [text1 drawInRect:CGRectMake(img.size.width - strSize.width - left - 10*(waterScale - 1.0),top *waterScale, strSize.width*waterScale, strSize.height*waterScale) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}


@end
