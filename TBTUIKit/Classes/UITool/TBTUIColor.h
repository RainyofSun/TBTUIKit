//
//  TBTUIColor.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static UIColor* TBTRGBColor(CGFloat r,CGFloat g,CGFloat b) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@interface TBTUIColor : NSObject

/**
 * 333333
 */
+ (UIColor *)mainDarkColor;
/**
 * 999999
 */
+ (UIColor *)lightDarkColor;
/**
 * 绿色
 */
+ (UIColor *)mainThemeColor;
/**
 * 黑色
 */
+ (UIColor *)darkThemeColor;
/**
 * 浅灰色
 */
+ (UIColor *)lightThemeColor;
/**
 * eeeeee
 */
+ (UIColor *)lightGrayLineColor;
/**
 * f2f2f2
 */
+ (UIColor *)lightGrayBackgroundColor;

@end

NS_ASSUME_NONNULL_END
