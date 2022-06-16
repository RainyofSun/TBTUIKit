//
//  TBTUIFont.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTUIFont.h"

@implementation TBTUIFont

+ (UIFont *)getFontWithStyle:(TBTFontStyle)fontStyle isBold:(BOOL)bold {
    switch (fontStyle) {
        case TBTFontStyle_Medium:
            return bold ? [UIFont boldSystemFontOfSize:17] : [UIFont systemFontOfSize:17];
        case TBTFontStyle_Large:
            return bold ? [UIFont boldSystemFontOfSize:20] : [UIFont systemFontOfSize:20];
        case TBTFontStyle_little:
            return bold ? [UIFont boldSystemFontOfSize:12] : [UIFont systemFontOfSize:12];
        default:
            return bold ? [UIFont boldSystemFontOfSize:14] : [UIFont systemFontOfSize:14];
    }
}

+ (UIFont *)getFontWithStyle:(TBTFontStyle)fontStyle fontWeight:(UIFontWeight)weight {
    switch (fontStyle) {
        case TBTFontStyle_Medium:
            return [UIFont systemFontOfSize:17 weight:weight];
        case TBTFontStyle_Large:
            return [UIFont systemFontOfSize:20 weight:weight];
        case TBTFontStyle_little:
            return [UIFont systemFontOfSize:12 weight:weight];
        default:
            return [UIFont systemFontOfSize:14 weight:weight];
    }
}

+ (UIFont *)getFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold {
    if (fontSize < 12) {
        return [self getFontWithStyle:TBTFontStyle_Normal isBold:bold];
    }
    return bold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
}

@end
