//
//  TBTUIPaddingConfig.h
//  TBTUIKit
//
//  Created by 苍蓝猛兽 on 2022/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBTUIPaddingConfig : NSObject

/**
 * 边缘Padding -- 基础单位是20px，
 * 计算公式 result = max(20 * scale,20)
 */
+ (CGFloat)tbt_edagePaddingWithScale:(CGFloat)scale;

/**
 * 控件间的距离 最小距离单位 4px
 * 计算公式 result = max(4 * scale,4)
 */
+ (CGFloat)tbt_widgetPaddingWithScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
