//
//  UIView+WalkSubview.m
//  
//
//  Created by Stephen Liu on 3/15/13.
//  Copyright (c) 2013 Stephen. All rights reserved.
//

#import "UIView+WalkSubview.h"
#import "CADisplayLink+Block.h"
#import <objc/runtime.h>

static char kDisplayLinkobjKey;

@implementation UIView (WalkSubview)
- (void)walkSubview:(void (^)(UIView *view, BOOL *stop))walk
{
	[self walkSubviewShoulStop:walk];
}

- (BOOL)walkSubviewShoulStop:(void (^)(UIView *view, BOOL *stop))walk
{
	BOOL stop = NO;
    for (UIView *view in self.subviews) {
		
		walk(view,&stop);
		
		if (stop) {
			return YES;
		}
		
        stop = [view walkSubviewShoulStop:walk];
		
		if (stop) {
			return YES;
		}
    }
	return NO;
}

- (BOOL)isShowingScreenInKeyWindow
{
    return [self isShowingScreenInKeyWindow:UIEdgeInsetsZero minRatio:0.];
}

- (BOOL)isShowingScreenInKeyWindow:(UIEdgeInsets)edges minRatio:(CGFloat)minRatio
{
    if(!self.window) return NO;
    
    if(self.hidden || self.superview.hidden || self.alpha < 0.01) return NO;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect convertRect = [keyWindow convertRect:self.frame fromView:self.superview];
    if(convertRect.size.width <=0 || convertRect.size.height <= 0) {
        return NO;
    }
    
    CGRect windowRect = keyWindow.bounds;
    windowRect.origin.x = edges.left;
    windowRect.origin.y = edges.top;
    windowRect.size.width -= (edges.left + edges.right);
    windowRect.size.height -= (edges.top + edges.bottom);
    
    CGRect insectRect = CGRectIntersection(windowRect, convertRect);
    CGFloat ratio = (insectRect.size.width*insectRect.size.height) / (convertRect.size.width*convertRect.size.height);
    if(isnan(ratio) || ratio < minRatio) {
        return NO;
    }
    
     BOOL intersects = CGRectIntersectsRect(windowRect, convertRect);
    return intersects && self.window == keyWindow;
}

- (BOOL)isShowingInView:(UIView *)view
{
    if(!view.superview) return NO;
    
    if(CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        return NO;
    }
    
    if(self.hidden || self.alpha < 0.01) return NO;
    
    CGRect insetRect = CGRectIntersection(self.frame, view.superview.bounds);
    bool isNull = CGRectIsNull(insetRect);
    if(isNull) {
        return NO;
    }
    
    return YES;
    
}

- (void)monitorViewShowInScreen:(void (^)(BOOL showingScreen, BOOL *stop))handler
{
    CADisplayLink *lastDisplayLink = objc_getAssociatedObject(self, &kDisplayLinkobjKey);
    if(lastDisplayLink) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        CADisplayLink *displayLink = [CADisplayLink kk_displayLinkWithBlock:^(CADisplayLink *displayLink) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            BOOL inScreen = [strongSelf isShowingScreenInKeyWindow];
            BOOL shouldStop = NO;
            if(handler) {
                handler(inScreen, &shouldStop);
            }
            
            if(shouldStop == YES) {
                [displayLink invalidate];
                objc_setAssociatedObject(strongSelf, &kDisplayLinkobjKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }];
        
        objc_setAssociatedObject(self, &kDisplayLinkobjKey, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
}

- (UIViewController *)getCurrentViewController {
    UIResponder *nextResponder =  self;
    
    do {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    } while (nextResponder != nil);
    return nil;
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    __block  UIView *it = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull child, NSUInteger idx, BOOL * _Nonnull stop) {
        it = [child descendantOrSelfWithClass:cls];
        if(it) {
            *stop = YES;
        }
    }];
    
    return it;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

@end
