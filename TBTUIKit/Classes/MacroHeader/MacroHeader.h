//
//  MacroHeader.h
//  TBT
//
//  Created by 刘冉 on 2022/6/10.
//

#ifndef MacroHeader_h
#define MacroHeader_h

#define DECL_WEAK_SELF __weak typeof(self) weakSelf = self;
#define CHECK_WEAK_SELF __strong typeof(weakSelf) strongSelf = weakSelf;if(!strongSelf) return;

#define WEAKIFY(var) \
    __weak typeof(var) TBTWeak_##var = var;
#define STRONGIFY(var) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wshadow\"") \
    __strong typeof(var) var = TBTWeak_##var; \
    _Pragma("clang diagnostic pop")

#define isRunningOniOS9     ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0)
#define isRunningOniOS10    ([[[UIDevice currentDevice] systemVersion] floatValue]>=10.0)
#define isRunningOniOS11    ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0)
#define isRunningOniOS12    ([[[UIDevice currentDevice] systemVersion] floatValue]>=12.0)
#define isRunningOniOS13    ([[[UIDevice currentDevice] systemVersion] floatValue]>=13.0)
#define isRunningOniOS14    ([[[UIDevice currentDevice] systemVersion] floatValue]>=14.0)
#define isRunningOniOS15    ([[[UIDevice currentDevice] systemVersion] floatValue]>=15.0)
#define isRunningOniOS16    ([[[UIDevice currentDevice] systemVersion] floatValue]>=16.0)
#define isAvailableiOS9     @available(iOS 9.0, *)
#define isAvailableiOS10    @available(iOS 10.0, *)
#define isAvailableiOS11    @available(iOS 11.0, *)
#define isAvailableiOS12    @available(iOS 12.0, *)
#define isAvailableiOS13    @available(iOS 13.0, *)
#define isAvailableiOS14    @available(iOS 14.0, *)
#define isAvailableiOS15    @available(iOS 15.0, *)
#define isAvailableiOS16    @available(iOS 16.0, *)

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

#define TBT_isiPhoneX_XS      (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define TBT_isiPhoneXR_XSMax  (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)
#define TBT_isiPhone12_12Pro  (kScreenWidth == 390.f && kScreenHeight == 844.f ? YES : NO)
#define TBT_isiPhone12MINI    ([UIDevice isiPhone12MINI])
#define TBT_isiPhone12ProMax  (kScreenWidth == 428.f && kScreenHeight == 926.f ? YES : NO)
#define TBT_isFullScreen (TBT_isiPhoneX_XS || TBT_isiPhoneXR_XSMax || TBT_isiPhone12_12Pro || TBT_isiPhone12ProMax) //异性全面屏

#define TBT_StatusBarHeight              [UIDevice getStatusBarHight]
#define TBT_StatusBarHeight_ForceHeight  (TBT_isFullScreen ? TBT_StatusBarHeight : 0)
#define TBT_NavigationBarHeight          [UIDevice getNavBarHight]
#define TBT_StatusAndNavBarHeight        (TBT_StatusBarHeight + TBT_NavigationBarHeight)
#define TBT_TabbarHeight                 (49.f + TBT_TabbarSafeBottomMargin)
#define TBT_TabbarSafeBottomMargin       (TBT_isFullScreen ? 34.f : 0.f)
#define TBT_iphonexTableInset            UIEdgeInsetsMake(TBT_StatusAndNavBarHeight, 0.f, TBT_TabbarHeight, 0.f)

//序列化快速归档解档 使用时需要导入<objc/runtime.h>
#define KSERIALIZE_CODER_DECODER() \
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
Class class = [self class];\
while (class != [NSObject class]) {\
unsigned int propertyCount = 0;\
objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);\
for (int i = 0; i < propertyCount; i ++) {\
objc_property_t property = propertyList[i];\
NSString *key = [NSString stringWithUTF8String:property_getName(property)];\
[self setValue:[aDecoder decodeObjectForKey:key] forKey:key];\
}\
free(propertyList);\
class = class_getSuperclass(class);\
}\
return self;\
}

#define KSERIALIZE_CODER_ENCODER()\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
Class class = [self class];\
while (class != [NSObject class]) {\
unsigned int propertyCount = 0;\
objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);\
for (int i = 0; i < propertyCount; i ++) {\
objc_property_t property = propertyList[i];\
NSString *key = [NSString stringWithUTF8String:property_getName(property)];\
id value = [self valueForKey:key];\
[aCoder encodeObject:value forKey:key];\
}\
free(propertyList);\
class = class_getSuperclass(class);\
}\
}

#endif /* MacroHeader_h */
