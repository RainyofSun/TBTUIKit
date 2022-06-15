//
//  NSDate+Utilites.h
//  GHLibrary
//
//  Created by Stephen Liu on 13-10-26.
//  Copyright (c) 2013年 Stephen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilites)
- (NSString *)dateString;
#pragma mark - 获取当前时间时间戳 单位毫秒
+ (NSString *)timestampString;
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)timeWithString:(NSString *)timeString;
- (NSString *)timeString;
- (NSString *)detailTimeStringYYYYMMddHH;
- (NSString *)relativeFormattedString:(BOOL)detail;
- (NSString *)highResolutionTimeString;
+ (NSDate *)highResolutionTimeWithString:(NSString *)timeString;

+ (BOOL)judgeDateIsToday:(NSDate *)date;
+ (BOOL)judgeExceedHalfDay:(NSDate *)date;

- (NSString *)hourDateString;
- (NSString *)mouthDayString;
- (NSString *)timeStringRelativeNow; /**< 如: 1分钟前 */
- (NSString *)timeStringForLiveHQ;  //直播问答,今天,明天,几月几日

- (NSString *)timeStringRelativeInterval:(NSTimeInterval)interval;
- (NSString *)dateStringWithFormatter:(NSString *)formatter;
@end
