//
//  NSDate+Utilites.m
//  GHLibrary
//
//  Created by Stephen Liu on 13-10-26.
//  Copyright (c) 2013年 Stephen Liu. All rights reserved.
//

#import "NSDate+Utilites.h"

@implementation NSDate (Utilites)
+ (NSString *)timestampString {
    return [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970]*1000.0)];
}

+ (NSDateFormatter *)dateFormatterFromCurrentThread
{
    NSThread * currentThread = [NSThread currentThread];
    NSDateFormatter * dateFormatter = [[currentThread threadDictionary] objectForKey:@"threadFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [[currentThread threadDictionary] setObject:dateFormatter forKey:@"threadFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateformatter = [self dateFormatterFromCurrentThread];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    return dateformatter;
}

+ (NSDateFormatter *)monthDayFormatter
{
    
    NSDateFormatter *dateformatter = [self dateFormatterFromCurrentThread];
    [dateformatter setDateFormat:@"MM-dd"];
    return dateformatter;
}

+ (NSDateFormatter *)hourDateFormatter
{
    NSDateFormatter *dateformatter = [self dateFormatterFromCurrentThread];
    [dateformatter setDateFormat:@"HH:mm"];
    return dateformatter;
}

- (NSString *)hourDateString
{
    return [[NSDate hourDateFormatter] stringFromDate:self];
}

- (NSString *)mouthDayString
{
    return [[NSDate monthDayFormatter] stringFromDate:self];
}

- (NSString *)dateString
{
	return [[NSDate dateFormatter] stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    return [[self dateFormatter] dateFromString:string];
}

+ (NSDateFormatter *)timeFormatter
{
    NSDateFormatter *timeFormatter = [self dateFormatterFromCurrentThread];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return timeFormatter;
}

+ (NSDateFormatter *)highResolutionTimeFormatter
{
    NSDateFormatter *timeFormatter = [self dateFormatterFromCurrentThread];
    [timeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return timeFormatter;
}

+ (NSDateFormatter *)detailTimeFormatter
{
    NSDateFormatter *formatter =  [self dateFormatterFromCurrentThread];;
    [formatter setDateFormat:@"yyyyMMddHH"];
    return formatter;
}

+ (NSDateFormatter *)hourMinuteSecondsFormatter
{
    NSDateFormatter *timeFormatter = [self dateFormatterFromCurrentThread];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    return timeFormatter;
}

+ (NSDate *)highResolutionTimeWithString:(NSString *)timeString
{
    return [[self highResolutionTimeFormatter] dateFromString:timeString];
}

- (NSString *)highResolutionTimeString
{
    return [[NSDate highResolutionTimeFormatter] stringFromDate:self];
}

+ (NSDate *)timeWithString:(NSString *)timeString
{
    return [[self timeFormatter] dateFromString:timeString];
}

- (NSString *)timeString
{
    return [[NSDate timeFormatter] stringFromDate:self];
}

- (NSString *)detailTimeStringYYYYMMddHH
{
    return [[NSDate detailTimeFormatter] stringFromDate:self];
}

- (BOOL)prefers24Hour {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:22];
    NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    NSString *testString = [formatter stringFromDate:testDate];
    return [[testString substringToIndex:1] isEqualToString:@"2"];
}

- (NSString *)relativeFormattedString:(BOOL)detail
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    
    NSDateFormatter *dateFormatter = [[self class] dateFormatterFromCurrentThread];
    
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    NSDateComponents *yesterdayComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(-24*60*60)]];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    
    NSString *formattedString = @"";
    
    BOOL today =  ([nowComponents year] == [dateComponents year] &&
                   [nowComponents month] == [dateComponents month] &&
                   [nowComponents day] == [dateComponents day]);
    if (today) {
        
    } else if([yesterdayComponents year] == [dateComponents year] &&
       [yesterdayComponents month] == [dateComponents month] &&
       [yesterdayComponents day] == [dateComponents day])          // 昨天
    {
        formattedString = @"昨天";
    }
    else if ([dayComponents day] < 7)
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:locale];
        dateFormatter.dateFormat=@"EEEE";
        formattedString = [[dateFormatter stringFromDate:self] capitalizedString];
    } else {
        NSLocale *mainlandChinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:mainlandChinaLocale];
        [dateFormatter setDateFormat:@"yyyy-M-d"];
        
        formattedString = [dateFormatter stringFromDate:self];
    }
    
    BOOL prefer24Hour = [self prefers24Hour];
    if (detail || today)				// 今天.
    {
        if (prefer24Hour)
        {
            [dateFormatter setDateFormat:@"HH:mm"];
        }
        else
        {
            [dateFormatter setDateFormat:@"hh:mm"];
        }
        
        NSString * timeStr = [dateFormatter stringFromDate:self];
        if (formattedString.length) {
            formattedString = [formattedString stringByAppendingString:@" "];
        }
        if (!prefer24Hour)
        {
            if([dateComponents hour] > 12)
            {
                formattedString = [formattedString stringByAppendingFormat:@"%@%@", @"下午", timeStr];
            }
            else
            {
                formattedString = [formattedString stringByAppendingFormat:@"%@%@", @"上午", timeStr];
            }
        }
        else if ([dateComponents hour] >= 0 && [dateComponents hour] <= 5)
        {
            formattedString = [formattedString stringByAppendingFormat:@"%@%02ld:%02ld", @"凌晨", (long)[dateComponents hour], (long)[dateComponents minute]];
        }
        else
        {
            formattedString = [formattedString stringByAppendingString:timeStr];
        }
    }
    return formattedString;
}

+ (BOOL)judgeDateIsToday:(NSDate *)date
{
    NSString *dateString = [date dateString];
    
    NSDate *nowDate = [NSDate date];
    NSString *nowString = [nowDate dateString];
    
    if([dateString isEqualToString:nowString]) {
       
        return YES;
    }
    
    return NO;
}

+ (BOOL)judgeExceedHalfDay:(NSDate *)date
{
    if (!date) {
        date = [NSDate date];
    }
    NSDate *nowDate = [NSDate date];
    NSTimeInterval  timeInterval = [nowDate timeIntervalSinceDate:date];
    if (timeInterval < 12*60*60) {
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)timeStringRelativeNow
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self];
    NSString *timeStr = nil;
    
    if(interval < 0) { //将来时间，暂显示 yyyy-MM-dd 格式
        timeStr = [self dateString];
    }else if(interval < 60) { //1分钟前
        timeStr = @"1分钟前";
    }else if(interval < 60*60) {
        NSUInteger minute = interval / 60;
        timeStr = [NSString stringWithFormat:@"%zd%@",minute,@"分钟前"];
    }else if(interval < 60*60 *24) {
        NSUInteger hour = interval / (60 *60);
        timeStr = [NSString stringWithFormat:@"%zd%@",hour,@"小时前"];
    }else if(interval < 60 * 60 *24*31) {
        NSUInteger day = interval / (60 *60*24);
        timeStr = [NSString stringWithFormat:@"%zd%@",day,@"天前"];
    }else if(interval < 60 *60 *24 *365) {
        timeStr =[self mouthDayString];
    }else {
        timeStr = [self dateString];
    }
    return timeStr;
}

- (NSString *)timeStringForLiveHQ
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateFormatter *dateFormatter = [[self class] dateFormatterFromCurrentThread];
    NSDateComponents *nowComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:unitFlags|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    NSDateComponents *tomorrowComponents = [calendar components:unitFlags fromDate:[[NSDate date] dateByAddingTimeInterval:(24*60*60)]];
    
    NSString *formattedString = @"";
    
    BOOL today =  ([nowComponents year] == [dateComponents year] &&
                   [nowComponents month] == [dateComponents month] &&
                   [nowComponents day] == [dateComponents day]);
    if (today)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        formattedString = [NSString stringWithFormat:@"%@ %@",@"今天",[dateFormatter stringFromDate:self]];
    }
    else if([tomorrowComponents year] == [dateComponents year] &&
            [tomorrowComponents month] == [dateComponents month] &&
            [tomorrowComponents day] == [dateComponents day])    // 昨天
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        formattedString = [NSString stringWithFormat:@"%@ %@",@"明天",[dateFormatter stringFromDate:self]];
    }
    else
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
        formattedString = [dateFormatter stringFromDate:self];
    }
    return formattedString;
}


- (NSString *)timeStringRelativeInterval:(NSTimeInterval)interval
{
    NSString *timeStr = nil;
    
    if(interval < 0) { //将来时间，暂显示 yyyy-MM-dd 格式
        timeStr = [self dateString];
    }else if(interval < 60) { //1分钟前
        timeStr = @"1分钟前";
    }else if(interval < 60*60) {
        NSUInteger minute = interval / 60;
        timeStr = [NSString stringWithFormat:@"%zd%@",minute,@"分钟前"];
    }else if(interval < 60*60 *24) {
        NSUInteger hour = interval / (60 *60);
        timeStr = [NSString stringWithFormat:@"%zd%@",hour,@"小时前"];
    }else if(interval < 60 * 60 *24*31) {
        NSUInteger day = interval / (60 *60*24);
        timeStr = [NSString stringWithFormat:@"%zd%@",day,@"天前"];
    }else if(interval < 60 *60 *24 *365) {
        timeStr =[self mouthDayString];
    }else {
        timeStr = [self dateString];
    }
    return timeStr;
}

- (NSString *)dateStringWithFormatter:(NSString *)formatter
{
    if(!formatter.length) {
        return nil;
    }
    NSDateFormatter *timeFormatter = [self.class dateFormatterFromCurrentThread];
    [timeFormatter setDateFormat:formatter];
    return [timeFormatter stringFromDate:self];;
    
}
@end
