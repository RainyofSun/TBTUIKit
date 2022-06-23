//
//  TBTRootViewController.m
//  TBTUIKit_Example
//
//  Created by 刘冉 on 2022/6/14.
//  Copyright © 2022 RainyofSun. All rights reserved.
//

#import "TBTRootViewController.h"
#import "TBTSecondViewController.h"
#import "TBTTestTableView.h"
#import "TBTAlertView.h"
#import <TBTUIKit/TBTUIKit-umbrella.h>

@interface TBTRootViewController ()

@property (nonatomic,strong) TBTTestTableView *testView;

@end

@implementation TBTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testTableView];
    [self testTimerBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.navigationController pushViewController:[[TBTSecondViewController alloc] init] animated:YES];
//    [self testAlert];
}

- (void)testTimerBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 160, 40);
    [btn startWithTime:59 title:@"获取" countDownTitle:@"获取" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(timerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)timerBtn:(UIButton *)sender {
    [sender startWithTime:59 title:@"获取" countDownTitle:@"获取" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
}

- (void)testAlert {
    
    NSMutableAttributedString *toastAttribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@"请确认注销账号",@"小花花",@"，注销成功后，本账号的所有相关信息都将无法找回。"]];
    NSRange frange = [toastAttribute.string rangeOfString:@"请确认注销账号"];
    NSRange srange = [toastAttribute.string rangeOfString:@"小花花"];
    NSRange trange = [toastAttribute.string rangeOfString:@"，注销成功后，本账号的所有相关信息都将无法找回。"];
    if (frange.location != NSNotFound && srange.location != NSNotFound && trange.location != NSNotFound) {
        [toastAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:frange];
        [toastAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColorString:@"999999"] range:frange];
        [toastAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:srange];
        [toastAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColorString:@"151515"] range:srange];
        [toastAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:trange];
        [toastAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexColorString:@"999999"] range:trange];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.lineSpacing = 5;
    [toastAttribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, toastAttribute.length - 1)];
    
    NSString *placeMessage = @"setting_toast_placehold";
    [placeMessage setObject:toastAttribute forAssociatedKey:k_alert_message_attr_key retained:YES];
    
    TBTAlertViewItem *cancelItem = [TBTAlertViewItem cancelItem];
    TBTAlertViewItem *continueItem = [[TBTAlertViewItem alloc] initWithAction:^(TBTBaseAlertView *alertView) {
        NSLog(@"点击确认");
    } title:@"确认"];
    continueItem.backgroundColor = [TBTUIColor mainThemeColor];
    cancelItem.backgroundColor = [UIColor cyanColor];
    TBTAlertView *alertView = [[TBTAlertView alloc] initWithTitle:@"测试弹窗" message:placeMessage items:@[continueItem]];
    [alertView show];
}

- (void)testTableView {
    [self.view addSubview:self.testView];
}

- (TBTTestTableView *)testView {
    if (!_testView) {
        _testView = [[TBTTestTableView alloc] initWithFrame:self.view.bounds];
    }
    return _testView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
