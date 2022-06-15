//
//  UIScrollView+Additions.m
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

- (void)scrollToTopAnimated:(BOOL)animated
{
    if (![self isAtTop]) {
        [self setContentOffset:[self topOffset] animated:animated];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if ([self canScrollToBottom]) {
        [self setContentOffset:[self bottomOffset] animated:animated];
    }
}

- (BOOL)isAtTop
{
    return (self.contentOffset.y <= [self topOffset].y) ? YES : NO;
}

- (BOOL)isAtBottom
{
    return (self.contentOffset.y >= [self bottomOffset].y) ? YES : NO;
}

- (CGPoint)topOffset
{
    return CGPointMake(self.contentOffset.x, -self.contentInset.top);
}

- (CGPoint)bottomOffset
{
    return CGPointMake(self.contentOffset.x, self.contentSize.height - self.bounds.size.height);
}

- (BOOL)canScrollToBottom
{
    if ([self isAtBottom]) {
        return NO;
    }
    return YES;
}

- (void)stopScrolling
{
    if (!self.isDragging) {
        return;
    }
    
    CGPoint offset = self.contentOffset;
    offset.y -= 1.0;
    [self setContentOffset:offset];
    
    offset.y += 1.0;
    [self setContentOffset:offset];
}

@end
