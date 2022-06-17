//
//  TBTAlertViewItem.h
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/17.
//

#import <Foundation/Foundation.h>

@class TBTBaseAlertView;
typedef void(^TBTAlertAction)(TBTBaseAlertView *alertView);

@interface TBTAlertViewItem : NSObject

/**
 The button action
 */
@property (nonatomic, copy) TBTAlertAction alertAction;
/**
 *  The button title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  The default font is bold system 16
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  The default color is white color
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  The default color is lightGrayColor
 */
@property (nonatomic, strong) UIColor *disableTitleColor;
/**
 *  The default backgroundColor is white color
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 The associate button
 */
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, assign) BOOL buttonEnable;
@property (nonatomic, assign) BOOL forbidAutoDismiss;

- (instancetype)initWithAction:(TBTAlertAction)alertAction;
- (instancetype)initWithAction:(TBTAlertAction)alertAction title:(NSString *)title;

+ (instancetype)itemWithAction:(TBTAlertAction)alertAction;
+ (instancetype)itemWithAction:(TBTAlertAction)alertAction title:(NSString *)title;
+ (instancetype)cancelItem;
+ (instancetype)comfirmItemWithAction:(TBTAlertAction)alertAction;

@end

typedef void (^ButtonActionBlock)(void);

@interface UIButton (Block)

- (void)handleButtonControlEvents:(UIControlEvents)controlEvent withBlock:(ButtonActionBlock)block;

@end
