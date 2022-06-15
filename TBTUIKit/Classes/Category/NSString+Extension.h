//
//  NSString+Extension.h
//  test文本框中英文判断
//
//  Created by 张守敏 on 15/1/30.
//  Copyright (c) 2015年 YKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  计算字符串的字节长度
 */
+ (NSInteger)convertToInt:(NSString*)strtemp;

+ (NSInteger)circleStrLength:(NSString *)strtemp;

+ (BOOL)includeChinese:(NSString *)str;

/**
 *  判断传入的整个字符串是否只包含数字(N),大小写字母(E),中文(C),-,_(UL)
 *
 *  @param str 需要
 *
 *  @return NO表示包含非法字符
 *  @return YES表示不包含非法字符
 */
+ (BOOL)judgeOnlyIncludeCENUL:(NSString *)str;
/**
 *   判断传入的整个字符串是否只包含数字(N),大小写字母(E),中文(C)
 *  @param str 字符串
 *
 *  @return NO表示包含非法字符
 *  @return YES表示不包含非法字符
 */
+ (BOOL)judgeOnlyIncludeCEN:(NSString *)str;
/**
 *  判断是否只包含数字
 *
 *  @param str 字符串
 *
 *  @return yes代表只包含数字,no表示包含数字之外的
 */
+ (BOOL)judgeOnlyIncludeNumber:(NSString *)str;

/**
 *   返回特定行间距，字号，排列方式的富文本
 */
- (NSAttributedString *)attributeString:(NSString *)originStr lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

/**
 *  私聊、评论超过字数限制提示tip文字  
 */
+ (NSString *)inputTextOverTips:(NSInteger)num;

/**
 *  判断字符串是否长度在100以内 只包含字母和数字
 */
+ (BOOL)judgeOnlyIncludeNE:(NSString *)str limitedLength:(NSInteger)length;

/**
 *判断字符串是否存在nice合法的URL
 *返回正则匹配后的数组,如果没有将返回nil
 */
+ (NSArray<NSTextCheckingResult *> *)getValidURLString:(NSString *)originString;

/**
 *  返回带链接符号的NSAttributedString（前提是有nice合法的链接内容）
 */
- (NSAttributedString *)attributeStringWithURLAttributes:(NSDictionary *)URLTextAttrDic;

/**
 *  如果字符包含nice合法链接，将删除链接内容
 */
- (NSString *)stringByDeleteURLContents;

/**
 *  超过1万格式化   如11000  ->1.1万
 */
+ (NSString *)stringWithIntOverTenThousandFormat:(NSInteger)num;
/**
 *  超过10万格式化   如110000  ->11.0万
 */
+ (NSString *)stringWithIntHundredTenThousandFormat:(NSInteger)number;

// 过滤手机号码 138****0000，只要超过3位的，后面最多显示4个*号
+ (NSString *)securityPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)URLEncodedStringWithUrl:(NSString *)url;

- (NSString *)urlStr;

+ (NSString *)curTimeStr;

// 判断是否是中文
- (BOOL)includeChinese;

+ (NSString *)cstrToNSString:(const char *)cstr;
+ (NSString *)int64ToNSString:(uint64_t)int64;
+ (NSString *)cstrToNSStringWithUTF8Encode:(const char *)cstr;

@end
