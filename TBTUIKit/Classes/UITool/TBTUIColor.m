//
//  TBTUIColor.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTUIColor.h"

@implementation TBTUIColor

+ (UIColor *)mainDarkColor {
    return TBTRGBColor(51.f, 51.f, 51.f);
}

+ (UIColor *)lightDarkColor {
    return TBTRGBColor(153.f, 153.f, 153.f);
}

+ (UIColor *)mainThemeColor {
    return TBTRGBColor(38.f, 191.f, 107.f);
}

+ (UIColor *)darkThemeColor {
    return [UIColor blackColor];
}

+ (UIColor *)lightThemeColor {
    return [UIColor lightGrayColor];
}

+ (UIColor *)lightGrayLineColor {
    return TBTRGBColor(238.f, 238.f, 238.f);
}

+ (UIColor *)lightGrayBackgroundColor {
    return TBTRGBColor(242, 242, 242);
}

@end
