//
//  TBTBaseAlertView.m
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/17.
//

#import "TBTBaseAlertView.h"
#import "TBTUIKit/MacroHeader.h"
#import <TBTUIKit/TBTUIFont.h>
#import <TBTUIKit/TBTUIColor.h>
#import <TBTUIKit/UIView+TBTViewExtension.h>
#import <TBTUIKit/NSString+Size.h>
#import <TBTUIKit/NSObject+AssociatedObject.h>
#import <TBTUIKit/TBTNSObjectExtension.h>

/*
 自定义弹窗message富文本属性key
 */
void *k_alert_message_attr_key = &k_alert_message_attr_key;

@interface TBTBaseAlertView ()

@property (nonatomic, strong) UIControl *dimmingView;
@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) NSDictionary *options; /**< 配置相关信息*/

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation TBTBaseAlertView

+ (instancetype)alertWithTitle:(NSString *)title okTitle:(NSString *)okTitle {
    return [self alertWithTitle:title message:nil okTitle:okTitle];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle {
    return [self alertWithTitle:title message:message cancelTitle:nil okTitle:okTitle cancel:nil complete:nil];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(TBTBaseAlertView * _Nonnull))cancelBlock complete:(void (^)(TBTBaseAlertView * _Nonnull))completeBlock {
    return [self alertWithTitle:title message:message cancelTitle:@"取消" okTitle:@"确定" cancel:cancelBlock complete:completeBlock];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle cancel:(void (^)(TBTBaseAlertView * _Nonnull))cancelBlock complete:(void (^)(TBTBaseAlertView * _Nonnull))completeBlock {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:kAlertMaxNumberOfButtons];
    if (cancelTitle.length) {
        [items addObject:[[TBTAlertViewItem alloc] initWithAction:cancelBlock title:cancelTitle]];
    }
    if (okTitle.length) {
        [items addObject:[[TBTAlertViewItem alloc] initWithAction:completeBlock title:okTitle]];
    }
    return [self alertWithTitle:title message:message items:items];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message items:(NSArray<TBTAlertViewItem *> *)items {
    TBTBaseAlertView *alertView = [[self alloc] initWithTitle:title message:message items:items];
    [alertView show];
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message items:(NSArray<TBTAlertViewItem *> *)items {
    return [self initWithTitle:title message:message alertWidth:kAlterViewWidth items:items];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertWidth:(CGFloat)alertWidth items:(NSArray<TBTAlertViewItem *> *)items {
    return [self initWithTitle:title message:message alertWidth:alertWidth customView:nil customViewWidth:alertWidth - 2*kAlertCustomViewLeftMargin items:items];
}

- (instancetype)initWithCustomView:(UIView *)customView customViewWidth:(CGFloat)customViewWidth alertWidth:(CGFloat)alertWidth items:(NSArray<TBTAlertViewItem *> *)items {
    return [self initWithTitle:nil message:nil alertWidth:alertWidth customView:customView customViewWidth:customViewWidth items:items];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertWidth:(CGFloat)alertWidth customView:(UIView *)customView customViewWidth:(CGFloat)customViewWidth items:(NSArray<TBTAlertViewItem *> *)items {
    return [self initWithTitle:title message:message alertWidth:alertWidth customView:customView customViewWidth:customViewWidth items:items options:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertWidth:(CGFloat)alertWidth customView:(UIView *)customView customViewWidth:(CGFloat)customViewWidth items:(NSArray<TBTAlertViewItem *> *)items options:(NSDictionary *)options {
    self = [super init];
    if (self) {
        [self initProperties];
        self.options = options;
        _alertViewWidth = alertWidth > 0 ? alertWidth : kAlterViewWidth;
        self.title = title;
        self.message = message;
        self.items = [items mutableCopy];
        self.customView = customView;
        self.customViewWidth = customViewWidth;
        _showOnCustomWindow = NO;
        
        [self setUpUI];
        
        self.layer.cornerRadius = kAlertViewCornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)initProperties {
    self.backgroundColor = [UIColor whiteColor];
    self.dimmingViewColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.dimmingEnable = NO;
}

#pragma mark - 虚方法由子类覆写
- (void)setUpUI {
    
}

- (void)show {
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    [self.dimmingView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[TBTBaseAlertView class]]) {
            [self dismissWithAlertItem:nil];
            *stop = YES;
        }
    }];
    
    if (_showOnCustomWindow) {
        _customWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _customWindow.hidden = NO;
        _customWindow.windowLevel = UIWindowLevelAlert + 100;
        [_customWindow addSubview:self.dimmingView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.dimmingView];
    }
    
    UIViewController *currrentVC = [TBTNSObjectExtension topViewController];
    currrentVC.editing = NO;
    
    [self alertViewAnimation];
}

- (void)dismissWithAlertItem:(TBTAlertViewItem *)alertItem {
    if (_customWindow) {
        _customWindow = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithAlertItem:)]) {
        [self.delegate alertView:self willDismissWithAlertItem:alertItem];
    }
    if (!alertItem.forbidAutoDismiss && alertItem.alertAction) {
        alertItem.alertAction(self);
    }
    [UIView transitionWithView:self.dimmingView duration:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        [self.dimmingView removeFromSuperview];
        self.dimmingView = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithAlertItem:)]) {
            [self.delegate alertView:self didDismissWithAlertItem:alertItem];
        }
        if (self.dissmissAction) {
            self.dissmissAction();
        }
    }];
}

#pragma mark - private methods
- (void)alertViewAnimation {
    self.frame = CGRectMake(0, 0, self.alertViewWidth, self.alertViewHeight);
    self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    [self.dimmingView addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [UIView animateWithDuration:0.25 delay:0.01 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [self.delegate didPresentAlertView:self];
        }
    }];
}

#pragma mark - UI
- (UILabel *)setUpTitleLabel:(CGFloat)top {
    if (self.title.length) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = kAlertTitleLabelLineSpacing;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        UIFont *titleFont = [TBTUIFont getFontWithSize:16 isBold:YES];
        NSDictionary *titleAtt = @{NSParagraphStyleAttributeName:paragraphStyle,
                                   NSFontAttributeName:titleFont,
                                   NSForegroundColorAttributeName:[TBTUIColor mainDarkColor]
        };
        NSAttributedString *titleAttStr = [[NSAttributedString alloc] initWithString:self.title attributes:titleAtt];
        [_titleLabel setAttributedText:titleAttStr];
        CGSize titleSize = [_titleLabel.attributedText boundingRectWithSize:CGSizeMake(self.titleLabel.FW, kAlertTitleLabelMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
        CGFloat fontH = titleFont.lineHeight;
        _titleLabel.FH = ceilf(titleSize.height);
        if (_titleLabel.FH < fontH * 2 + kAlertTitleLabelLineSpacing - 2) {
            _titleLabel.attributedText = nil;
            _titleLabel.font = titleFont;
            _titleLabel.textColor = [TBTUIColor mainDarkColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = self.title;
            _titleLabel.FH = [self.title tbt_sizeWithFont:titleFont width:_titleLabel.FW].height;
        }
        _titleLabel.FT = top;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (NSTextAlignment)messageAlignment {
    if(!self.options) {
        return NSTextAlignmentCenter;
    }
    NSNumber *number = [self.options objectForKey:TBTAlertViewMessageAlignment];
    if(!number) return NSTextAlignmentCenter;
    return [number integerValue];
}

- (UILabel *)setupMessageLabel:(CGFloat)top {
    CGFloat messageFontHeight;
    if (self.message.length) {
        NSAttributedString *messageAttStr = nil;
        NSAttributedString *associateAttributeText = [self.message objectWithAssociatedKey:k_alert_message_attr_key];
        UIFont *font = [TBTUIFont getFontWithStyle:TBTFontStyle_Normal isBold:NO];
        if (associateAttributeText.length) {
            messageAttStr = associateAttributeText;
        } else {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = kAlertMessageLabelLineSpacing;
            paragraphStyle.alignment = [self messageAlignment];
            NSDictionary *messageAtt = @{NSParagraphStyleAttributeName:paragraphStyle,
                                         NSFontAttributeName:font,
                                         NSForegroundColorAttributeName:[TBTUIColor lightDarkColor]
            };
            messageAttStr = [[NSAttributedString alloc] initWithString:self.message attributes:messageAtt];
        }
        CGSize messageLabSize = [messageAttStr boundingRectWithSize:CGSizeMake(self.messageLabel.FW, kAlertMessageLabelMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
        _messageLabel.FH = ceilf(messageLabSize.height);
        [_messageLabel setAttributedText:messageAttStr];
        
        CGFloat labelW = self.alertViewWidth - kAlertTitleLabelLeftMargin - kAlertTitleLabelRightMargin;
        messageFontHeight = font.lineHeight;
        if (associateAttributeText.length == 0 && _messageLabel.FH < messageFontHeight * 2 + kAlertMessageLabelLineSpacing - 2) {
            _messageLabel.attributedText = nil;
            _messageLabel.font = font;
            _messageLabel.textColor = [TBTUIColor lightDarkColor];
            _messageLabel.textAlignment = [self messageAlignment];
            _messageLabel.text = self.message;
            _messageLabel.FH = [self.message tbt_sizeWithFont:font width:labelW].height;
        }
        _messageLabel.FT = top;
        [self addSubview:self.messageLabel];
    }
    return _messageLabel;
}

- (void)setupButtons:(CGFloat)previousViewBottom {
    NSAssert(self.items.count > 0, @"you must add at least one TBTAlertViewItem");
    if (self.items.count == 2) {
        CGFloat buttonWidth = self.alertViewWidth/2 - kAlertMessageLabelLeftMargin * 3;
        UIButton *button;
        for (int i = 0; i < self.items.count; i++) {
            TBTAlertViewItem *item = [self.items objectAtIndex:i];
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(kAlertMessageLabelLeftMargin * 2 + i*(buttonWidth + kAlertMessageLabelLeftMargin * 2), previousViewBottom + kAlertButtonTopMargin, buttonWidth, kAlertButtonHeight);
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            [button setTitleColor:item.disableTitleColor forState:UIControlStateDisabled];
            button.titleLabel.font = item.titleFont;
            button.backgroundColor = item.backgroundColor;
            button.enabled = item.buttonEnable;
            button.layer.cornerRadius = 4.f;
            button.clipsToBounds = YES;
            item.button = button;
            DECL_WEAK_SELF
            [button handleButtonControlEvents:UIControlEventTouchUpInside withBlock:^{
                CHECK_WEAK_SELF
                if (item.forbidAutoDismiss) {
                    if (item.alertAction) {
                        item.alertAction(strongSelf);
                    }
                } else {
                    [strongSelf dismissWithAlertItem:item];
                }
            }];
            [self addSubview:button];
        }
        self.alertViewHeight = CGRectGetMaxY(button.frame) + kAlertTopMargin;
    } else {
        UIButton *button;
        CGFloat buttonWidth = self.alertViewWidth - 2*kAlertButtonLeftMargin;
        for (int i = 0; i < self.items.count ; i++) {
            if (i >= kAlertMaxNumberOfButtons) {
                break;
            }
            
            TBTAlertViewItem *item = [self.items objectAtIndex:i];
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(kAlertButtonLeftMargin, previousViewBottom + kAlertButtonTopMargin + i*(kAlertButtonHeight + kAlertButtonMargin), buttonWidth, kAlertButtonHeight);
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitleColor:item.titleColor forState:UIControlStateNormal];
            button.titleLabel.font = item.titleFont;
            button.backgroundColor = item.backgroundColor;
            [button setTitleColor:item.disableTitleColor forState:UIControlStateDisabled];
            button.enabled = item.buttonEnable;
            button.layer.cornerRadius = 4.f;
            button.clipsToBounds = YES;
            item.button = button;
            DECL_WEAK_SELF
            [button handleButtonControlEvents:UIControlEventTouchUpInside withBlock:^{
                CHECK_WEAK_SELF
                if (item.forbidAutoDismiss) {
                    if (item.alertAction) {
                        item.alertAction(strongSelf);
                    }
                } else {
                    [strongSelf dismissWithAlertItem:item];
                }
            }];
            [self addSubview:button];
        }
        self.alertViewHeight = CGRectGetMaxY(button.frame);
    }
}

- (void)resetUI {
    if (self.items.count) {
        while (self.subviews.count) {
            UIView* child = self.subviews.lastObject;
            [child removeFromSuperview];
        }
        [self setUpUI];
        self.frame = CGRectMake(0, 0, self.alertViewWidth, self.alertViewHeight);
        self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    }
}

- (void)touchDimmingView:(UIControl *)sender {
    if (self.dimmingEnable) {
        [self dismissWithAlertItem:nil];
    }
}

#pragma mark - property
- (UIControl *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dimmingView.backgroundColor = self.dimmingViewColor;
        [_dimmingView addTarget:self action:@selector(touchDimmingView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dimmingView;
}

- (void)setAlertViewWidth:(CGFloat)alertViewWidth {
    _alertViewWidth = alertViewWidth;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat labelWidth = self.alertViewWidth - kAlertTitleLabelLeftMargin - kAlertTitleLabelRightMargin;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertTitleLabelLeftMargin, 0, labelWidth, 0)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertTitleLabelLeftMargin, 0, self.alertViewWidth - kAlertTitleLabelLeftMargin - kAlertTitleLabelRightMargin, 15)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([[NSThread currentThread] isMainThread]) {
        [self resetUI];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetUI];
        });
    }
}

- (void)setMessage:(NSString *)message {
    _message = message;
    if ([[NSThread currentThread] isMainThread]) {
        [self resetUI];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetUI];
        });
    }
}

@end
