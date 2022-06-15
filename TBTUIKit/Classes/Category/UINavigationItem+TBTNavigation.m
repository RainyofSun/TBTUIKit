//
//  UINavigationItem+TBTNavigation.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "UINavigationItem+TBTNavigation.h"
#import "NSObject+AssociatedObject.h"

@implementation UINavigationItem (TBTNavigation)

- (BOOL)hideNavigationBar {
    return [[self objectWithAssociatedKey:@selector(hideNavigationBar)] boolValue];
}

- (void)setHideNavigationBar:(BOOL)hideNavigationBar {
    [self setObject:@(hideNavigationBar) forAssociatedKey:@selector(hideNavigationBar) retained:YES];
}

- (BOOL)hideNavigationBarOnSwipe {
    return [[self objectWithAssociatedKey:@selector(hideNavigationBarOnSwipe)] boolValue];
}

- (void)setHideNavigationBarOnSwipe:(BOOL)hideNavigationBarOnSwipe {
    [self setObject:@(hideNavigationBarOnSwipe) forAssociatedKey:@selector(hideNavigationBarOnSwipe) retained:YES];
}

-(NSInteger)popEffectiveWidth {
    id obj = [self objectWithAssociatedKey:@selector(popEffectiveWidth)];
    if (obj) {
        return  [obj integerValue];
    } else {
        return [UIScreen mainScreen].bounds.size.width;
    }
}

- (void)setPopEffectiveWidth:(NSInteger)width {
    NSNumber *num = [NSNumber numberWithInteger:width];
    [self setObject:num forAssociatedKey:@selector(popEffectiveWidth) retained:YES];
}

@end
