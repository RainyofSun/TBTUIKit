//
//  TBTUIFont.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TBTFontStyle_little,    // 12 号
    TBTFontStyle_Normal,    // 14 号
    TBTFontStyle_Medium,    // 17 号
    TBTFontStyle_Large      // 20 号
}TBTFontStyle;

@interface TBTUIFont : NSObject

+ (UIFont *)getFontWithStyle:(TBTFontStyle)fontStyle isBold:(BOOL)bold;
+ (UIFont *)getFontWithStyle:(TBTFontStyle)fontStyle fontWeight:(UIFontWeight)weight;
+ (UIFont *)getFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold;

@end

NS_ASSUME_NONNULL_END
