//
//  UIDevice+Utilities.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "UIDevice+Utilities.h"
#import "MacroHeader.h"
#import <sys/utsname.h>

@implementation UIDevice (Utilities)

+ (CGFloat)getNavBarHight {
    return 49;
}

+ (CGFloat)getStatusBarHight
{
    CGFloat statusBarHeight = 0;
    //直接采用完整的高度列表
    //    iPhone11: 48                  忽略
    //    iPhone12/12 pro/12 pro max: 47
    //    iPhone12 mini: 50
    //    iPad Pro、IPad Air: 24         忽略
    //    Other iPhones: 44
    //    非刘海屏：20
    if (TBT_isiPhone12_12Pro || TBT_isiPhone12ProMax) {
        statusBarHeight = 47;
    }else if(TBT_isiPhone12MINI){
        statusBarHeight = 50;
    }else if(TBT_isFullScreen){
        if (@available(iOS 14, *)) {
            if (([self isiPhoneXR] || [self isiPhone11])) {
                statusBarHeight = 48;
            } else {
                statusBarHeight = 44;
            }
        } else {
            statusBarHeight = 44;
        }
    }else{
        statusBarHeight = 20;
    }
    return statusBarHeight;
}

+ (BOOL)isiPhoneXR
{
    static NSString *platform;
    if (platform.length == 0) {
        struct utsname systemInfo;
        uname(&systemInfo);
        platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return ([platform isEqualToString:@"iPhone11,8"]);
}

+ (BOOL)isiPhone11
{
    static NSString *platform;
    if (platform.length == 0) {
        struct utsname systemInfo;
        uname(&systemInfo);
        platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return ([platform isEqualToString:@"iPhone12,1"]);
}

+ (BOOL)isiPhone12MINI
{
    static NSString *platform;
    if (platform.length == 0) {
        struct utsname systemInfo;
        uname(&systemInfo);
        platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return ([platform isEqualToString:@"iPhone13,1"]);
}

@end
