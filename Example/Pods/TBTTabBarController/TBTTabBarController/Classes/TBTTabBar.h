//
//  TBTTabBar.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <UIKit/UIKit.h>
#import "TBTTabBarItem.h"

@class TBTTabBar;

NS_ASSUME_NONNULL_BEGIN

@protocol TBTTabBarDelegate <NSObject>

/**
 * Asks the delegate if the specified tab bar item should be selected.
 */
- (BOOL)tabBar:(TBTTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/**
 * Tells the delegate that the specified tab bar item is now selected.
 */
- (void)tabBar:(TBTTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface TBTTabBar : UIView

/**
 * The tab bar’s delegate object.
 */
@property (nonatomic, weak) id <TBTTabBarDelegate> delegate;

/**
 * The items displayed on the tab bar.
 */
@property (nonatomic, copy) NSArray *items;

/**
 * The currently selected item on the tab bar.
 */
@property (nonatomic, weak) TBTTabBarItem *selectedItem;

/**
 * backgroundView stays behind tabBar's items. If you want to add additional views,
 * add them as subviews of backgroundView.
 */
@property (nonatomic, readonly) UIView *backgroundView;

/*
 * contentEdgeInsets can be used to center the items in the middle of the tabBar.
 */
@property UIEdgeInsets contentEdgeInsets;

/**
 * Sets the height of tab bar.
 */
- (void)setHeight:(CGFloat)height;

/**
 * Returns the minimum height of tab bar's items.
 */
- (CGFloat)minimumContentHeight;

/*
 * Enable or disable tabBar translucency. Default is NO.
 */
@property (nonatomic, getter=isTranslucent) BOOL translucent;

/*
 * Enable or disable tabBar top gray line. Default is YES.
 */
@property (nonatomic, getter=isShowGrayLine) BOOL showGrayLine;

@end

NS_ASSUME_NONNULL_END
