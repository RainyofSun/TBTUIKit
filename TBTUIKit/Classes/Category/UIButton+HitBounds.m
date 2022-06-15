//
//  UIButton+HitBounds.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "UIButton+HitBounds.h"
#import <objc/runtime.h>

@implementation UIButton (HitBounds)
@dynamic hitEdgeInsets;

-(void)setHitEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, @selector(hitEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(hitEdgeInsets));
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
