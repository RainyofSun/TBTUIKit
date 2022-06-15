//
//  UIDevice+Utilities.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Utilities)

+ (CGFloat)getStatusBarHight;
+ (CGFloat)getNavBarHight;
+ (BOOL)isiPhone12MINI;

@end

NS_ASSUME_NONNULL_END
