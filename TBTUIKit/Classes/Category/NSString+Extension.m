//
//  NSString+Extension.m
//  test文本框中英文判断
//
//  Created by 张守敏 on 15/1/30.
//  Copyright (c) 2015年 YKH. All rights reserved.
//

#import "NSString+Extension.h"
#import <sys/time.h>

@implementation NSString (Extension)
+ (NSInteger)convertToInt:(NSString*)strtemp
{
    NSInteger strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

// 字符长度
+ (NSInteger)circleStrLength:(NSString *)strtemp
{
    // 中文输入法会带入特殊的空格，这种空格算成一个字符长度
    char cString[] = "\u2006";
    NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
    NSString *bigWhiteSpace = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    __block NSInteger count = 0;
    [strtemp enumerateSubstringsInRange:NSMakeRange(0, strtemp.length)
                                options:NSStringEnumerationByComposedCharacterSequences
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 NSUInteger substrlen = [substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                                 if (substrlen<=1 || [substring isEqualToString:bigWhiteSpace]) {
                                     count++;
                                 }
                                 else {
                                     count+=2;
                                 }
                             }];
    return count;
}

+ (BOOL)includeChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fff){
            return YES;
        }
    } return NO;
}

+ (BOOL)judgeOnlyIncludeCENUL:(NSString *)str
{
    NSString *regex = @"[a-zA-Z0-9\u3400-\u9fff-_ ]+";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if(![pred evaluateWithObject:str]) return NO;
    
    return YES;
}

+ (BOOL)judgeOnlyIncludeCEN:(NSString *)str
{
    NSString * regex = @"[a-zA-Z0-9\u3400-\u9fff]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:str]) return NO;
    return YES;
}

+ (BOOL)judgeOnlyIncludeNumber:(NSString *)str
{
    NSString * regex = @"^[0-9]*$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

- (NSAttributedString *)attributeString:(NSString *)originStr lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:originStr];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:lineSpacing];
    paraStyle.alignment  = textAlignment;
    NSRange range = NSMakeRange(0,originStr.length);
    [string addAttributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:font} range:range];
    return string;
}

+ (NSString *)inputTextOverTips:(NSInteger)num
{
    NSString *tipStr = nil;
    tipStr = [NSString stringWithFormat:@"%@%ld",@"字数不能超过",(long)num];
    return tipStr;
}

+ (BOOL)judgeOnlyIncludeNE:(NSString *)str limitedLength:(NSInteger)length
{
    if (str.length > length || str.length == 0) {
        return NO;
    }else
    {
        NSString *regex = @"[a-zA-Z0-9]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if(![pred evaluateWithObject:str]){
            return NO;
        }else{
            return YES;
        }
    }
}


+ (NSArray<NSTextCheckingResult *> *)getValidURLString:(NSString *)originString
{
    NSError *error;
    NSRegularExpression *urlRegular = [NSRegularExpression regularExpressionWithPattern:[self getValidURLRegularExpression] options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchsUrlReg = [urlRegular matchesInString:originString
                                                options:NSMatchingReportProgress
                                                  range:NSMakeRange(0, [originString length])];
    return matchsUrlReg;
}

/**
 *判断字符串是否存在nice合法的URL
 */
+ (NSString *)getValidURLRegularExpression
{
    NSArray *supportedHost = @[@"tbt.cn"]; // TODO 需要抓包确认
    NSMutableString *hostReg = [NSMutableString stringWithString:@""];
    [supportedHost enumerateObjectsUsingBlock:^(NSString *host, NSUInteger idx, BOOL * _Nonnull stop) {
        [hostReg appendString:[NSString stringWithFormat:@"%@|",host]];
    }];
    if ([[hostReg substringWithRange:NSMakeRange(hostReg.length - 1, 1)] isEqualToString:@"|"]) {
        [hostReg deleteCharactersInRange:NSMakeRange(hostReg.length - 1, 1)];
    }
    NSString *urlReg = [NSString stringWithFormat:@"https?:\\/\\/[a-zA-Z0-9.]{0,10}(%@)[%%a-zA-Z0-9_\\-\\/\u4e00-\u9fa5\?=&\\.:]*",[hostReg copy]];
    return urlReg;
}

- (NSAttributedString *)attributeStringWithURLAttributes:(NSDictionary *)URLTextAttrDic
{
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:self];
    NSArray *matchsUrlReg = [NSString getValidURLString:self];
    if (matchsUrlReg.count > 0) {
        __block NSInteger preLength = contentString.length;
        [matchsUrlReg enumerateObjectsUsingBlock:^(NSTextCheckingResult *urlMatchResult, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange realURLRange = NSMakeRange(urlMatchResult.range.location - (preLength - contentString.length), urlMatchResult.range.length);
            NSAttributedString *realUrlAttr = [NSString niceURLAttributestring:URLTextAttrDic];
            [contentString replaceCharactersInRange:realURLRange withAttributedString:realUrlAttr];
        }];
    }
    return contentString;
}

+ (NSAttributedString *)niceURLAttributestring:(NSDictionary *)textAttrDic
{
    NSTextAttachment *imageAttch = [[NSTextAttachment alloc] init];
    imageAttch.image = [UIImage imageNamed:@"URLlink_icon"];
    imageAttch.bounds = CGRectMake(0, -1, imageAttch.image.size.width, imageAttch.image.size.height);
    NSMutableAttributedString *URLAttributeString = [[NSMutableAttributedString attributedStringWithAttachment:imageAttch] mutableCopy];
    NSMutableAttributedString *spaceAttr = [[NSMutableAttributedString alloc] initWithString:@"  "];
    [spaceAttr appendAttributedString:URLAttributeString];
    NSAttributedString *textAttr = [[NSAttributedString alloc] initWithString:@" 网页链接" attributes:textAttrDic];
    [spaceAttr appendAttributedString:textAttr];
    return spaceAttr;
}

- (NSString *)urlStr {
    
    NSArray *matchsUrlReg = [NSString getValidURLString:self];
    __block NSString *url = nil;
    [matchsUrlReg enumerateObjectsUsingBlock:^(NSTextCheckingResult *urlMatchResult, NSUInteger idx, BOOL * _Nonnull stop) {
        url = [self substringWithRange:urlMatchResult.range];
    }];
    return url;
}

- (NSString *)stringByDeleteURLContents
{
    NSMutableString *commentString = [self mutableCopy];
    NSArray *matchsUrlReg = [NSString getValidURLString:self];
    if (matchsUrlReg.count > 0) {
        __block NSInteger preLength = commentString.length;
        [matchsUrlReg enumerateObjectsUsingBlock:^(NSTextCheckingResult *urlMatchResult, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange realURLRange = NSMakeRange(urlMatchResult.range.location - (preLength - commentString.length), urlMatchResult.range.length);
            [commentString deleteCharactersInRange:realURLRange];
        }];
    }
    return commentString;

}

+ (NSString *)stringWithIntOverTenThousandFormat:(NSInteger)number
{
    if(number < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
    NSString *text = nil;
    text = [NSString stringWithFormat:@"%.1lf万",number/10000.0];
    NSRange range =[text rangeOfString:@".0"];
    if(range.location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    return text;

}

+ (NSString *)stringWithIntHundredTenThousandFormat:(NSInteger)number
{
    if(number < 100000) {
        return [NSString stringWithFormat:@"%ld",(long)number];
    }
    NSString *text = nil;
    text = [NSString stringWithFormat:@"%.1lf万",number/10000.0];
    NSRange range =[text rangeOfString:@".0"];
    if(range.location != NSNotFound) {
        text = [text stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    return text;

}

+ (NSString *)securityPhoneNumber:(NSString *)phoneNumber {
    
    NSMutableString *muStr = [phoneNumber mutableCopy];
    
    for (int i = 0; i < 4; i++) {
        if ([muStr length] > i + 3) {
            NSRange range = NSMakeRange(i + 3, 1);
            [muStr replaceCharactersInRange:range withString:@"*"];
        }
    }
    return muStr;
}

+ (NSString *)URLEncodedStringWithUrl:(NSString *)url
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)curTimeStr
{
    struct timeval tv_begin;
    gettimeofday(&tv_begin, NULL);
    __darwin_suseconds_t microseconds =  tv_begin.tv_usec;
    long long currentTime = (long long)tv_begin.tv_sec*100000+microseconds;
    return [NSString stringWithFormat:@"%lld",currentTime];
}

- (BOOL)includeChinese {
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)cstrToNSString:(const char *)cstr {
    return [NSString stringWithFormat:@"%s",cstr];
}

+ (NSString *)int64ToNSString:(uint64_t)int64 {
    return [NSString stringWithFormat:@"%llu",int64];
}

+ (NSString *)cstrToNSStringWithUTF8Encode:(const char *)cstr {
    return [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
}

@end
