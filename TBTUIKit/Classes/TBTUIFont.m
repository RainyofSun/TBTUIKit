//
//  TBTUIFont.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTUIFont.h"

@implementation TBTUIFont

+ (UIFont *)getFontWithStyle:(TBTFontStyle)fontStyle {
    switch (fontStyle) {
        case TBTFontStyle_Medium:
            return [UIFont systemFontOfSize:17];
        case TBTFontStyle_Large:
            return [UIFont systemFontOfSize:20];
        case TBTFontStyle_little:
            return [UIFont systemFontOfSize:12];
        default:
            return [UIFont systemFontOfSize:14];
    }
}

+ (UIFont *)getFontWithSize:(CGFloat)fontSize {
    if (fontSize < 12) {
        return [self getFontWithStyle:TBTFontStyle_Normal];
    }
    return [UIFont systemFontOfSize:fontSize];
}

@end
