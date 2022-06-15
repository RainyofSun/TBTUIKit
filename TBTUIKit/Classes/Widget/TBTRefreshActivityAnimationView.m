//
//  TBTRefreshActivityAnimationView.m
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/15.
//

#import "TBTRefreshActivityAnimationView.h"
#import "UIView+TBTViewExtension.h"
#import "UIColor+Hex.h"

@interface TBTRefreshActivityAnimationView ()
{
    UILabel *_statusLabel;
}
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation TBTRefreshActivityAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 19.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor colorWithHexColorString:@"999999"];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.FCX = self.FW * 0.5;
        _indicatorView.FCY = self.FH * 0.5;
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)startAnimations {
    [_indicatorView startAnimating];
}

- (void)stopAnimations {
    [_indicatorView stopAnimating];
}

- (void)setStatusLabText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self->_statusLabel.hidden = !text.length;
        }];
        self->_statusLabel.text = text;
    });
}

@end
