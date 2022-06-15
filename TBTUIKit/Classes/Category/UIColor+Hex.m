//
//  UIColor+Hex.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexColorString:(NSString*)inColorString {
    return [UIColor colorWithHexColorString:inColorString withAlpha:1.0];
}

+ (UIColor*)colorWithHexColorString:(NSString*)inColorString withAlpha:(CGFloat)alpha {
    UIColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if ([inColorString hasPrefix:@"#"]) {
        inColorString = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    if (nil != inColorString)
    {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    if ([inColorString length] == 8) {   //如果是8位，就那其中的alpha
        alpha = (float)(unsigned char)(colorCode >> 24) /0xff;
    }
    
    result = [UIColor
              colorWithRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:alpha];
    return result;
}

+ (UIColor *)randomColor {
    CGFloat r = (CGFloat)drand48();
    CGFloat g = (CGFloat)drand48();
    CGFloat b = (CGFloat)drand48();
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
