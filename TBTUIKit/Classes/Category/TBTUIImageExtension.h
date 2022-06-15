//
//  TBTUIImageExtension.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBTUIImageExtension : NSObject

/**
 根据颜色组合生成图片
 */
+ (UIImage *)getGradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
