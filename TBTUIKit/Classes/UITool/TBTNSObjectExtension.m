//
//  TBTNSObjectExtension.m
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/17.
//

#import "TBTNSObjectExtension.h"
#import <TBTTabBarController/TBTTabBarController.h>

@implementation TBTNSObjectExtension

+ (UIViewController *)topViewController {
    return [self getCurrentVC:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)getCurrentVC:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被present出来的
        rootVC = [rootVC presentedViewController];
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 视图为 UITabbarController
        currentVC = [self getCurrentVC:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // 视图为 UINavigationController
        currentVC = [self getCurrentVC:[(UINavigationController *)rootVC visibleViewController]];
    } else if ([rootVC isKindOfClass:[TBTTabBarController class]]) {
        // 视图为自定义的 TBTTabBarController
        currentVC = [self getCurrentVC:[(TBTTabBarController *)rootVC selectedViewController]];
    } else {
        // 视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
