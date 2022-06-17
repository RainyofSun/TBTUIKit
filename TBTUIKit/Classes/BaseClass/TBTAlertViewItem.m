//
//  TBTAlertViewItem.m
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/17.
//

#import "TBTAlertViewItem.h"
#import <TBTUIKit/TBTUIFont.h>
#import <TBTUIKit/TBTUIColor.h>
#import <objc/runtime.h>

@implementation TBTAlertViewItem

+ (instancetype)cancelItem {
    return [[self alloc] initWithAction:nil title:@"取消"];
}

+ (instancetype)comfirmItemWithAction:(TBTAlertAction)alertAction {
    return [[self alloc] initWithAction:alertAction title:@"确定"];
}

+ (instancetype)itemWithAction:(TBTAlertAction)alertAction {
    return [[self alloc] initWithAction:alertAction];
}

+ (instancetype)itemWithAction:(TBTAlertAction)alertAction title:(NSString *)title {
    return [[self alloc] initWithAction:alertAction title:title];
}

- (instancetype)initWithAction:(TBTAlertAction)alertAction {
    return [self initWithAction:alertAction title:nil];
}

- (instancetype)initWithAction:(TBTAlertAction)alertAction title:(NSString *)title {
    self = [super init];
    if (self) {
        _alertAction = alertAction;
        _title = title;
        _titleFont = [TBTUIFont getFontWithSize:16 isBold:YES];
        _titleColor = [UIColor whiteColor];
        _backgroundColor = TBTRGBColor(242, 245, 249);
        _buttonEnable = YES;
        _disableTitleColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end

static char kButtonEventBlockKey;

@implementation UIButton (Block)

- (void)handleButtonControlEvents:(UIControlEvents)controlEvent withBlock:(ButtonActionBlock)block {
    objc_setAssociatedObject(self, &kButtonEventBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonEvents:) forControlEvents:controlEvent];
}

- (void)buttonEvents:(id)sender {
    ButtonActionBlock block = (ButtonActionBlock)objc_getAssociatedObject(self, &kButtonEventBlockKey);
    if (block) {
        block();
    }
}

@end
