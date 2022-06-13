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

+ (UIColor *)mainDarkColor;
+ (UIColor *)lightDarkColor;
+ (UIColor *)mainThemeColor;
+ (UIColor *)darkThemeColor;
+ (UIColor *)lightThemeColor;

+ (UIColor *)lightGrayLineColor;

@end

NS_ASSUME_NONNULL_END
