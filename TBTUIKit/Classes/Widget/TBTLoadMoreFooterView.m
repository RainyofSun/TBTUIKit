//
//  TBTLoadMoreFooterView.m
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import "TBTLoadMoreFooterView.h"
#import "UIColor+Hex.h"
#import "UIView+TBTViewExtension.h"
#import "UIView+WalkSubview.h"
#import "NSString+Size.h"

#define TEXT_COLOR     [UIColor colorWithHexColorString:@"999999"]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation TBTLoadMoreFooterView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 19.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
                
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(55.0f, 10.0f, 14.0f, 14.0f);
        [self addSubview:view];
        _activityView = view;
        view.FCY = label.FCY;
        _activityView.hidesWhenStopped = YES;
        self.hidden = YES;
        [self setState:LoadMoreNormal];
    }
    return self;
}


#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)state
{
    [self setState:state scrollView:nil];
}

- (void)setState:(LoadMoreState)aState scrollView:(UIScrollView *)scrollView
{
    if (!scrollView) {
        scrollView = (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
    }
    if (_state == aState) {
        return;
    }
    self.hidden = NO;
    switch (aState) {
        case LoadMorePulling:
            _statusLabel.text = @"释放加载更多";
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, self.defaultContentInset, 0.0f);
            CGSize size = [_statusLabel.text tbt_sizeWithFont:[UIFont systemFontOfSize:13]];
            _statusLabel.FT = 10;
            _statusLabel.FSize = size;
            _statusLabel.FCX = self.FW * 0.5;
            break;
        case LoadMoreNormal:
            _statusLabel.text = @"上拉加载更多";
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, self.defaultContentInset, 0.0f);
            _statusLabel.FT = 10;
            _statusLabel.FSize = [_statusLabel.text tbt_sizeWithFont:[UIFont systemFontOfSize:13]];
            _statusLabel.FCX = self.FW * 0.5;
            _activityView.FCY = _statusLabel.FCY;
            _activityView.FR = _statusLabel.FL - 8;
            [_activityView stopAnimating];
            break;
        case LoadMoreLoading:
            _statusLabel.text = @"正在加载";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, self.defaultContentInset+40.0f, 0.0f);
            [UIView commitAnimations];
            _statusLabel.FT = 10;
            _statusLabel.FSize = [_statusLabel.text tbt_sizeWithFont:[UIFont systemFontOfSize:13]];
            _statusLabel.FCX = self.FW * 0.5;
            _activityView.FCY = _statusLabel.FCY;
            _activityView.FR = _statusLabel.FL - 8;
            [_activityView startAnimating];
            break;
        case LoadMoreNone:
            _statusLabel.text = @"没有了";
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0.0f, self.defaultContentInset, 0.0f);
            _statusLabel.FT = 10;
            _statusLabel.FSize = [_statusLabel.text tbt_sizeWithFont:[UIFont systemFontOfSize:13]];
            _statusLabel.FCX = self.FW * 0.5;
            _activityView.FCY = _statusLabel.FCY;
            _activityView.FR = _statusLabel.FL - 8;
            [_activityView stopAnimating];
            self.hidden = YES;
            break;
        default:
            break;
    }
    
    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == LoadMoreNone) {
        return;
    }
    if (scrollView.isDragging) {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        if (_loading) {
            return;
        }
        self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height - 60.0f)))
        {
            [self setState:LoadMorePulling];
        } else {
            [self setState:LoadMoreNormal];
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (_state == LoadMoreNone) {
        return;
    }
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
        _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
    }
    if (_loading) {
        return;
    }
    if (scrollView.contentOffset.y > (MAX(scrollView.contentSize.height,scrollView.FH) - (scrollView.FH - 60.0f)) && !_loading) {
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL _loading = NO;
            if ([self->_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
                _loading = [self->_delegate loadMoreTableFooterDataSourceIsLoading:self];
            }
            if (_loading) {
                [self setState:LoadMoreLoading];
            } else {
                [self setState:LoadMoreNormal];
            }
        });
    } else {
        [self setState:LoadMoreNormal];
    }
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    if (_state != LoadMoreNone) {
        [self setState:LoadMoreNormal];
    }
    self.hidden = YES;
    self.frame = CGRectMake(0, scrollView.contentSize.height < scrollView.FH ? scrollView.FH:scrollView.contentSize.height,
                            self.frame.size.width, self.frame.size.height);
}

@end
