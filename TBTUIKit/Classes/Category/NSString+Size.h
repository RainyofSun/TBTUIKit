//
//  NSString+Size.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

- (CGSize)threadSafeSizeWithFont:(UIFont *)font;

- (CGSize)threadSafeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)tbt_sizeWithFont:(UIFont *)font;

- (CGSize)tbt_sizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

- (CGSize)tbt_sizeWithFont:(UIFont *)font width:(CGFloat)width;

- (CGSize)tbt_sizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)tbt_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)tbt_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode attributes:(NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
