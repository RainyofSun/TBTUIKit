//
//  TBTUIColor.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTUIColor.h"

@implementation TBTUIColor

+ (UIColor *)mainDarkColor {
    return TBTRGBColor(19.f, 19.f, 19.f);
}

+ (UIColor *)lightDarkColor {
    return TBTRGBColor(164.f, 165.f, 166.f);
}

+ (UIColor *)mainThemeColor {
    return TBTRGBColor(3.f, 160.f, 235.f);
}

+ (UIColor *)darkThemeColor {
    return [UIColor blackColor];
}

+ (UIColor *)lightThemeColor {
    return [UIColor lightGrayColor];
}

+ (UIColor *)lightGrayLineColor {
    return TBTRGBColor(232.f, 234.f, 235.f);
}

@end
