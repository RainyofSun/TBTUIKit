//
//  NSTimer+TBTSafeTimer.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "NSTimer+TBTSafeTimer.h"

@interface TBTTimerTarget : NSObject
@property (nonatomic, weak)id target;
@property (nonatomic, assign)SEL selector;
- (void)fire:(NSTimer *)timer;
@end

@implementation TBTTimerTarget

- (void)fire:(NSTimer *)timer
{
    if (!_target) {
        [timer invalidate];
    } else if (_target && _selector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([_target respondsToSelector:_selector]) {
            [_target performSelector:_selector withObject:timer];
        }
#pragma clang diagnostic pop
    }
}

@end

@implementation NSTimer (TBTSafeTimer)

- (instancetype)tbt_initWithFireDate:(NSDate *)date
                           interval:(NSTimeInterval)ti
                             target:(id)t
                           selector:(SEL)s
                           userInfo:(id)ui
                            repeats:(BOOL)rep{
    TBTTimerTarget *target = [[TBTTimerTarget alloc] init];
    target.target = t;
    target.selector = s;
    return [self initWithFireDate:date
                         interval:ti
                           target:target
                         selector:@selector(fire:)
                         userInfo:ui
                          repeats:rep];
}

+ (instancetype)tbt_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                           target:(id)t
                                         selector:(SEL)s
                                         userInfo:(id)ui
                                          repeats:(BOOL)rep
{
    TBTTimerTarget *target = [[TBTTimerTarget alloc] init];
    target.target = t;
    target.selector = s;
    return [self scheduledTimerWithTimeInterval:ti
                                         target:target
                                       selector:@selector(fire:)
                                       userInfo:ui
                                        repeats:rep];
}

+ (instancetype)tbt_timerWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)t
                                selector:(SEL)s
                                userInfo:(id)ui
                                 repeats:(BOOL)rep
{
    TBTTimerTarget *target = [[TBTTimerTarget alloc] init];
    target.target = t;
    target.selector = s;
    return [self timerWithTimeInterval:ti
                                target:target
                              selector:@selector(fire:)
                              userInfo:ui
                               repeats:rep];
}

@end
