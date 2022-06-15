//
//  NSTimer+TBTSafeTimer.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (TBTSafeTimer)

- (instancetype)tbt_initWithFireDate:(NSDate *)date
                           interval:(NSTimeInterval)ti
                             target:(id)t
                           selector:(SEL)s
                           userInfo:(id)ui
                            repeats:(BOOL)rep;

+ (instancetype)tbt_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                           target:(id)t
                                         selector:(SEL)s
                                         userInfo:(id)ui
                                          repeats:(BOOL)rep;

+ (instancetype)tbt_timerWithTimeInterval:(NSTimeInterval)ti
                                  target:(id)t
                                selector:(SEL)s
                                userInfo:(id)ui
                                 repeats:(BOOL)rep;

@end

NS_ASSUME_NONNULL_END
