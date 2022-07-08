//
//  TBTTabBarController.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <UIKit/UIKit.h>
#import "TBTTabBar.h"

@class TBTTabBar,TBTTabBarController;
@protocol TBTTabBarControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@protocol TBTTabBarControllerDelegate <NSObject>
@optional
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(TBTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(TBTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface TBTTabBarController : UIViewController

/**
 * The tab bar controller’s delegate object.
 */
@property (nonatomic, weak) id<TBTTabBarControllerDelegate> delegate;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller. (read-only)
 */
@property (nonatomic, readonly) TBTTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 * A Boolean value that determines whether the tab bar is hidden.
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 * Changes the visibility of the tab bar.
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@class TBTTabBarItem,TBTTabBarController;

@interface UIViewController (TBTTabBarControllerItem)

/**
 * The tab bar item that represents the view controller when added to a tab bar controller.
 */
@property(nonatomic, setter = tbt_setTabBarItem:) TBTTabBarItem *tbt_tabBarItem;

/**
 * The nearest ancestor in the view controller hierarchy that is a tab bar controller. (read-only)
 */
@property(nonatomic, readonly) TBTTabBarController *tbt_tabBarController;

@end

NS_ASSUME_NONNULL_END
