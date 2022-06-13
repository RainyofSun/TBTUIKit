//
//  UIImage+TBTBundleImage.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TBTBundleImage)

+ (instancetype)tbt_imgWithName:(NSString *)name;
+ (instancetype)tbt_imgWithColor:(UIColor *)imgColor;

@end

NS_ASSUME_NONNULL_END
