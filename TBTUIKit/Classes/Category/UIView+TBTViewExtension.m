//
//  UIView+TBTViewExtension.m
//  TBT
//
//  Created by 刘冉 on 2022/6/13.
//

#import "UIView+TBTViewExtension.h"

@implementation UIView (TBTViewExtension)
@dynamic FL;
@dynamic FR;
@dynamic FT;
@dynamic FB;
@dynamic FW;
@dynamic FH;
@dynamic FCX;
@dynamic FCY;

#pragma mark - Get

- (CGFloat)FL {
    return self.frame.origin.x;
}

- (CGFloat)FR {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)FT {
    return self.frame.origin.y;
}

- (CGFloat)FB {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)FW {
    return self.frame.size.width;
}

- (CGFloat)FH {
    return self.frame.size.height;
}

- (CGFloat)FCX {
    return self.center.x;
}

- (CGFloat)FCY {
    return self.center.y;
}

-(CGSize)FSize {
    return self.frame.size;
}

#pragma mark - Set

- (void)setFL:(CGFloat)FL {
    CGRect rect = self.frame;
    rect.origin.x = FL;
    self.frame = rect;
}

- (void)setFR:(CGFloat)FR {
    CGRect rect = self.frame;
    rect.origin.x = FR - rect.size.width;
    self.frame = rect;
}

- (void)setFT:(CGFloat)FT {
    CGRect rect = self.frame;
    rect.origin.y = FT;
    self.frame = rect;
}

- (void)setFB:(CGFloat)FB {
    CGRect rect = self.frame;
    rect.origin.y = FB - rect.size.height;
    self.frame = rect;
}

- (void)setFW:(CGFloat)FW {
    CGRect rect = self.frame;
    rect.size.width = FW;
    self.frame = rect;
}

- (void)setFH:(CGFloat)FH {
    CGRect rect = self.frame;
    rect.size.height = FH;
    self.frame = rect;
}

- (void)setFCX:(CGFloat)FCX {
    CGPoint point = self.center;
    point.x = FCX;
    self.center = point;
}

- (void)setFCY:(CGFloat)FCY {
    CGPoint point = self.center;
    point.y = FCY;
    self.center = point;
}

-(void)setFSize:(CGSize)FSize {
    CGRect frame = self.frame;
    frame.size = FSize;
    self.frame = frame;
}

@end
