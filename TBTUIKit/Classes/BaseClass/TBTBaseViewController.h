//
//  TBTBaseViewController.h
//  Pods
//
//  Created by 刘冉 on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBTBaseViewController : UIViewController

/// Whether to enable the interactive pop gesture or not.
@property (nonatomic, assign) BOOL cl_interactivePopGestureEnabled;

/** set custom navigation leftItem */
-(void)createBackBtnWithImageName:(NSString *)imageName;
/** set custom navigation rightItem */
-(void)createNavRightBtnWithImageName:(NSString *)imageName;

/// Left bar back button event. Override this method if you'd like to do something for your needs.
- (void)cl_leftBarButtonClicked;
/// right bar item event. Override this method if you'd like to do something for your needs.
- (void)cl_rightBarButtonClicked;

/// This method won't be called until the swipe gesture ends up with page's disappearance. Override this method according to your needs.
/// For instance, maybe you want to do something else if the view controller disappears when pop gesture is completely released by user.
- (void)cl_popGestureDidEnd;

@end

@interface UIViewController (CLTransition)

/// Pop view controller.
- (void)cl_popVC;

///
/// Pop view controller from current view controller.
///
/// @param viewController A UIViewController or UINavigationController instance.
///
+ (void)cl_popVCFrom:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
