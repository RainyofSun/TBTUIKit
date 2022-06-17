//
//  TBTBaseAlertView.h
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/17.
//

#import <UIKit/UIKit.h>
#import "TBTAlertViewItem.h"
#import "TBTAlertConfigHeader.h"

@class TBTBaseAlertView;

/*
 自定义弹窗message富文本属性
 */
extern void *k_alert_message_attr_key;

@protocol TBTBaseAlertViewDelegate <NSObject>

@optional
//before animation and showing view
- (void)willPresentAlertView:(TBTBaseAlertView *)alertView;
// after animation
- (void)didPresentAlertView:(TBTBaseAlertView *)alertView;
// before animation and hiding view
- (void)alertView:(TBTBaseAlertView *)alertView willDismissWithAlertItem:(TBTAlertViewItem *)alertItem;
// after animation
- (void)alertView:(TBTBaseAlertView *)alertView didDismissWithAlertItem:(TBTAlertViewItem *)alertItem;

@end

typedef void(^DissmissAction)(void);

@interface TBTBaseAlertView : UIView

@property (nonatomic, weak) id<TBTBaseAlertViewDelegate>delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat alertViewHeight;
@property (nonatomic, copy) DissmissAction dissmissAction;
/**
 *  默认为\(^o^)/NO!，为NO则dimmingView不响应事件
 */
@property (nonatomic, assign) BOOL dimmingEnable;
@property (nonatomic, assign) BOOL showOnCustomWindow;
@property (nonatomic, strong) UIColor *dimmingViewColor;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, readonly) CGFloat alertViewWidth;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) CGFloat customViewWidth;
@property (nonatomic, readonly,strong) NSDictionary *options; /**< 配置相关信息*/

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message items:(NSArray <TBTAlertViewItem *> *)items;
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(TBTBaseAlertView *alertView))cancelBlock complete:(void (^)(TBTBaseAlertView *alertView))completeBlock;
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelTitle:(NSString *)cancelTitle
                       okTitle:(NSString *)okTitle
                        cancel:(void (^)(TBTBaseAlertView *alertView))cancelBlock
                      complete:(void (^)(TBTBaseAlertView *alertView))completeBlock;

+ (instancetype)alertWithTitle:(NSString *)title okTitle:(NSString *)okTitle;
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message items:(NSArray <TBTAlertViewItem *> *)items;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertWidth:(CGFloat)alertWidth items:(NSArray <TBTAlertViewItem *> *)items;
- (instancetype)initWithCustomView:(UIView *)customView customViewWidth:(CGFloat)customViewWidth alertWidth:(CGFloat)alertWidth items:(NSArray <TBTAlertViewItem *> *)items;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message alertWidth:(CGFloat)alertWidth customView:(UIView *)customView customViewWidth:(CGFloat)customViewWidth items:(NSArray <TBTAlertViewItem *> *)items options:(NSDictionary *)options;

/**
 Convenience method for initializing an custom alert view.

 @param title The string that appears in the receiver’s title bar.
 @param message Descriptive text that provides more details than the title.
 @param alertWidth The alertView width.
 @param customView The view you want to display on the alert.
 @param items The items must be contain at least one TBTAlertViewItem.
 @return Newly initialized custom alert view.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   alertWidth:(CGFloat)alertWidth
                   customView:(UIView *)customView
              customViewWidth:(CGFloat)customViewWidth
                        items:(NSArray <TBTAlertViewItem *> *)items;

// shows popup alert animated.
- (void)show;
// custom UI
- (void)setUpUI;
- (UILabel *)setUpTitleLabel:(CGFloat)top;
- (UILabel *)setupMessageLabel:(CGFloat)top;
- (void)setupButtons:(CGFloat)previousViewBottom;
// dismiss alert animation
- (void)dismissWithAlertItem:(TBTAlertViewItem *)alertItem;

@end
