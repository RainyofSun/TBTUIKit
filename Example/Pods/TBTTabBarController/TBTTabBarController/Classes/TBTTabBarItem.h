//
//  TBTTabBarItem.h
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBTTabBarItem : UIControl

/**
 * itemHeight is an optional property. When set it is used instead of tabBar's height.
 */
@property CGFloat itemHeight;

#pragma mark - Title configuration

/**
 * The title displayed by the tab bar item.
 */
@property (nonatomic, copy) NSString *title;

/**
 * The offset for the rectangle around the tab bar item's title.
 */
@property (nonatomic) UIOffset titlePositionAdjustment;

/**
 * The title attributes dictionary used for tab bar item's unselected state.
 */
@property (copy) NSDictionary *unselectedTitleAttributes;

/**
 * The title attributes dictionary used for tab bar item's selected state.
 */
@property (copy) NSDictionary *selectedTitleAttributes;

#pragma mark - Image configuration

/**
 * The offset for the rectangle around the tab bar item's image.
 */
@property (nonatomic) UIOffset imagePositionAdjustment;

/**
 * The image used for tab bar item's selected state.
 */
- (UIImage *)finishedSelectedImage;

/**
 * The image used for tab bar item's unselected state.
 */
- (UIImage *)finishedUnselectedImage;

/**
 * Sets the tab bar item's selected and unselected images.
 */
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Background configuration

/**
 * The background image used for tab bar item's selected state.
 */
- (UIImage *)backgroundSelectedImage;

/**
 * The background image used for tab bar item's unselected state.
 */
- (UIImage *)backgroundUnselectedImage;

/**
 * Sets the tab bar item's selected and unselected background images.
 */
- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Badge configuration

/**
 * Text that is displayed in the upper-right corner of the item with a surrounding background.
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 * Image used for background of badge.
 */
@property (strong) UIImage *badgeBackgroundImage;

/**
 * Color used for badge's background.
 */
@property (strong) UIColor *badgeBackgroundColor;

/**
 * Color used for badge's text.
 */
@property (strong) UIColor *badgeTextColor;

/**
 * The offset for the rectangle around the tab bar item's badge.
 */
@property (nonatomic) UIOffset badgePositionAdjustment;

/**
 * Font used for badge's text.
 */
@property (nonatomic) UIFont *badgeTextFont;

@end

NS_ASSUME_NONNULL_END
