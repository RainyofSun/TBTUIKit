//
//  UINavigationItem+TBTNavigation.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (TBTNavigation)

@property (nonatomic, assign)BOOL hideNavigationBar;
@property (nonatomic, assign)BOOL hideNavigationBarOnSwipe;
@property (nonatomic, assign)NSInteger popEffectiveWidth;

@end

NS_ASSUME_NONNULL_END
