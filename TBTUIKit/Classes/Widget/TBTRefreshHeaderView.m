//
//  TBTRefreshHeaderView.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "TBTRefreshHeaderView.h"
#import "TBTBaseRefreshHeaderView.h"
#import "UIColor+Hex.h"
#import "UIView+WalkSubview.h"
#import "MacroHeader.h"

#define TEXT_COLOR     [UIColor colorWithHexColorString:@"868686"]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation TBTRefreshHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (isRunningOniOS11) {
            _defaultContentInset = 0;
        } else {
            _defaultContentInset = 64;
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        _loadingView = [[TBTBaseRefreshHeaderView alloc] initWithFrame:CGRectMake(0, frame.size.height - 60.0f, frame.size.width, 60)];
        [self addSubview:_loadingView];
        
        [self setState:TBTPullRefreshNormal];
    }
    
    return self;
}

-(void)setDefaultContentInset:(CGFloat)defaultContentInset {
    if (isRunningOniOS11) {
        if (_defaultContentInset != 0) {
            _defaultContentInset = defaultContentInset-64;
        } else {
            _defaultContentInset = 0;
        }
    } else {
        _defaultContentInset = defaultContentInset;
    }
}

- (void)setIos11ContentInsetTop:(CGFloat)ios11ContentInsetTop {
    _ios11ContentInsetTop = ios11ContentInsetTop;
}

- (void)setCustomAnimator:(id<TBTRefreshHeaderAnimator>)customAnimator {
    if (customAnimator) {
        self.backgroundColor = [UIColor clearColor];
        _loadingView.hidden = YES;
    }
    _customAnimator = customAnimator;
}

- (void)setState:(TBTPullRefreshState)aState {
    [self setState:aState scrollView:nil];
}

- (void)setState:(TBTPullRefreshState)aState scrollView:(UIScrollView *)scrollView {
    if (aState == _state) {
        return;
    }
    _state = aState;
    if (self.customAnimator) {
        [self.customAnimator egoRefreshStateChanged:aState];
        return;
    }
    if (!scrollView) {
        scrollView = (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    switch (aState) {
        case TBTPullRefreshPulling:
        {
            [_loadingView stopAnimations];
            [scrollView setContentInset:UIEdgeInsetsMake(_defaultContentInset + _ios11ContentInsetTop, 0.0f, scrollView.contentInset.bottom, 0.0f)];
        }
            break;
        case TBTPullRefreshNormal:
        {
            [_loadingView stopAnimations];
            [scrollView setContentInset:UIEdgeInsetsMake(_defaultContentInset + _ios11ContentInsetTop, 0.0f, scrollView.contentInset.bottom, 0.0f)];
        }
            break;
        case TBTPullRefreshLoading:
        {
            [_loadingView startAnimations];
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, _loadingView.bounds.size.height)+_defaultContentInset + _ios11ContentInsetTop;
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, scrollView.contentInset.bottom, 0.0f);
        }
            break;
        default:
            break;
    }
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    if (_loading) {
        return;
    }
    if (scrollView.isDragging)
    {
        if (scrollView.contentOffset.y < -(_defaultContentInset + _ios11ContentInsetTop))
        {
            [self setState:TBTPullRefreshPulling];
        } else {
            [self setState:TBTPullRefreshNormal];
        }
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    if (_loading) {
        return;
    }
    
    CGFloat offY = -(65.0f+_defaultContentInset + _ios11ContentInsetTop);
    if (isRunningOniOS11) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            offY = -(65.0f+_defaultContentInset + _ios11ContentInsetTop +scrollView.adjustedContentInset.top);
        }
#endif
    }
    if (scrollView.contentOffset.y <= offY)
    {
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL _loading = NO;
            if ([self->_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
                _loading = [self->_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
            }
            if (_loading) {
                [self setState:TBTPullRefreshLoading];
            } else {
                [self setState:TBTPullRefreshNormal];
            }
        });
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [self setState:TBTPullRefreshNormal];
}

@end
