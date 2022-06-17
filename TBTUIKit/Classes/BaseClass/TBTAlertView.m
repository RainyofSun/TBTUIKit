//
//  TBTAlertView.m
//  TBTUIKit_Example
//
//  Created by 刘冉 on 2022/6/17.
//  Copyright © 2022 RainyofSun. All rights reserved.
//

#import "TBTAlertView.h"
#import <TBTUIKit/UIView+TBTViewExtension.h>

@implementation TBTAlertView

- (void)setUpUI {
    UILabel *titleLab = [self setUpTitleLabel:kAlertTopMargin];
    UILabel *messageLab = [self setupMessageLabel:titleLab ? titleLab.FB + kAlertMessageLabelTopMargin : kAlertTopMargin];
    CGFloat bottom = messageLab ? messageLab.FB : titleLab.FB;
    if (self.customView) {
        self.customView.FT = (!messageLab && !titleLab) ? 0 : bottom + kAlertCustomViewTopMargin;
        self.customView.FW = self.customViewWidth;
        self.customView.FCX = self.alertViewWidth/2;
        [self addSubview:self.customView];
        
        bottom = self.customView.FB;
    }
    [self setupButtons:bottom];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
