//
//  UIScrollView+Additions.h
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Additions)

/** The accurate CGPoint offset to reach the top of the scrollView. */
@property (nonatomic, readonly) CGPoint topOffset;
/** The accurate CGPoint offset to reach the bottom of the scrollView. */
@property (nonatomic, readonly) CGPoint bottomOffset;

/** YES if the scrollView's offset is at the very top. */
@property (nonatomic, readonly) BOOL isAtTop;
/** YES if the scrollView's offset is at the very bottom. */
@property (nonatomic, readonly) BOOL isAtBottom;
/** YES if the scrollView can scroll from it's current offset position to the bottom. */
@property (nonatomic, readonly) BOOL canScrollToBottom;

/**
 Sets the content offset to the top.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 Sets the content offset to the bottom.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 Stops scrolling, if it was scrolling.
 */
- (void)stopScrolling;

@end

NS_ASSUME_NONNULL_END
