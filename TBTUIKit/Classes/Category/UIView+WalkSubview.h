//
//  UIView+WalkSubview.h
//  
//
//  Created by Stephen Liu on 3/15/13.
//  Copyright (c) 2013 Stephen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^KKViewMonitorHandler)(BOOL showingScreen, BOOL *stop);
@interface UIView (WalkSubview)
- (void)walkSubview:(void (^)(UIView *view, BOOL *stop))walk;

/** 判断view是否在主窗口上显示 */
- (BOOL)isShowingScreenInKeyWindow;
/* minRatio 以面积为基准，占屏幕的比例。小于指定值，返回NO。可用于判断视图显示的区域大小 */
- (BOOL)isShowingScreenInKeyWindow:(UIEdgeInsets)edges minRatio:(CGFloat)minRatio;
- (BOOL)isShowingInView:(UIView *)view;

/** 实时监听view是否在屏幕上 */
- (void)monitorViewShowInScreen:(void (^)(BOOL showingScreen, BOOL *stop))handler;
/** 获取当前view 的控制器 */
- (UIViewController *)getCurrentViewController;
/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;
/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

@end
