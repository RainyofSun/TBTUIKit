//
//  UIColor+Hex.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

/*
    @"ffffff"       6 位代表透明度1
    @"ffffffff"     8 位代表前2位是16进制透明度,00是透明度0,ff是透明度1
 */
+ (UIColor*)colorWithHexColorString:(NSString*)inColorString;
+ (UIColor*)colorWithHexColorString:(NSString*)inColorString withAlpha:(CGFloat)alpha;
+ (UIColor*)randomColor;

@end

NS_ASSUME_NONNULL_END
