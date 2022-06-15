//
//  TBTTableView.m
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import "TBTTableView.h"
#import "TBTLoadMoreFooterView.h"
#import "TBTRefreshHeaderView.h"
#import "MacroHeader.h"
#import "UIView+TBTViewExtension.h"
#import "TBTBaseRefreshHeaderView.h"
#import "UIScrollView+Additions.h"

@interface UITableView()

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

@end

@interface TBTTableView ()<TBTRefreshHeaderDelegate,LoadMoreFooterDelegate>
{
    BOOL _refreshing;
    BOOL _loadingMore;
    BOOL _hasMore;
    
    BOOL _dealloced;
}

@property (nonatomic, weak)id<TBTTableViewDelegate> realDelegate;

@end

@implementation TBTTableView

- (void)dealloc {
    _dealloced = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITableViewSelectionDidChangeNotification object:nil];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initialSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSettings];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSettings];
    }
    return self;
}

- (void)initialSettings {
    _defaultContentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    _allowResetSelectedAndHighitedStatus = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tableViewSelectionDidChang)
                                                 name:UITableViewSelectionDidChangeNotification
                                               object:nil];
}

/**
 fix tableViewCell selected 时可能visibleCells都被置为Highlighted = YES的bug
 */
- (void)tableViewSelectionDidChang {
    if (self.allowsMultipleSelection || !_allowResetSelectedAndHighitedStatus) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] && self.delegate) {
            
            [self.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isHighlighted) {
                    [obj setHighlighted:NO animated:NO];
                }
                
                if (obj.isSelected) {
                    [obj setSelected:NO animated:NO];
                }
            }];
        }
    });
}

- (void)setEnablePullRefresh:(BOOL)enablePullRefresh {
    _enablePullRefresh = enablePullRefresh;
    if (!_enablePullRefresh) {
        [self didFinishRefreshing];
        [_refreshHeaderView removeFromSuperview];
        _refreshHeaderView = nil;
    } else {
        [self addRefreshHeaderView];
    }
}

- (void)addRefreshHeaderView {
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[TBTRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -500, self.frame.size.width, 500)];
        _refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _refreshHeaderView.defaultContentInset = self.defaultContentInset.top;
        [_refreshHeaderView setDelegate:self];
        [self addSubview:_refreshHeaderView];
    }
}

- (void)setEnablePullLoadingMore:(BOOL)enablePullLoadingMore {
    _enablePullLoadingMore = enablePullLoadingMore;
    if (!_enablePullLoadingMore) {
        [self didFinishLoadingMore];
        [_loadmoreFooterView removeFromSuperview];
        _loadmoreFooterView = nil;
    } else {
        [self addLoadmoreFooterView];
    }
}

- (void)addLoadmoreFooterView {
    if (!_loadmoreFooterView) {
        _loadmoreFooterView = [[TBTLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, 0)];
        _loadmoreFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_loadmoreFooterView setDelegate:self];
        _loadmoreFooterView.defaultContentInset = self.defaultContentInset.bottom;
        if (!_hasMore) {
            [_loadmoreFooterView setState:LoadMoreNone];
        }
        [self addSubview:_loadmoreFooterView];
    }
}

- (void)setDefaultContentInset:(UIEdgeInsets)defaultContentInset {
    _defaultContentInset = defaultContentInset;
    _refreshHeaderView.defaultContentInset = self.defaultContentInset.top;
    _loadmoreFooterView.defaultContentInset = self.defaultContentInset.bottom;
}

- (void)setHasMore:(BOOL)hasMore {
    _hasMore = hasMore;
    if (!hasMore) {
        [self didFinishLoadingMore];
        [_loadmoreFooterView setState:LoadMoreNone];
    } else if(!_loadingMore){
        [_loadmoreFooterView setState:LoadMoreNormal];
    }
}

- (BOOL)hasMore {
    return _hasMore;
}

- (void)didFinishRefreshing {
    _refreshing = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)didFinishLoadingMore {
    _loadingMore = NO;
    [_loadmoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self];
}

- (void)didFinishLoading {
    [self didFinishRefreshing];
    [self didFinishLoadingMore];
}

- (void)restartRefreshAnimationIfNeed {
    if (_refreshing) {
        [self.refreshHeaderView.loadingView startAnimations];
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.realDelegate = (id<TBTTableViewDelegate>)delegate;
    [super setDelegate:nil];
    if (!_dealloced) {
        [super setDelegate:self];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(TBTRefreshHeaderView *)view
{
    if ([_realDelegate respondsToSelector:@selector(tableViewDidTriggerRefresh:)]) {
        _refreshing = [_realDelegate tableViewDidTriggerRefresh:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_refreshing) {
            [view egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        }
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(TBTRefreshHeaderView*)view {
    return _refreshing;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(TBTRefreshHeaderView*)view {
    return [NSDate date];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(TBTLoadMoreFooterView *)view {
    return _loadingMore;
}

- (void)loadMoreTableFooterDidTriggerRefresh:(TBTLoadMoreFooterView *)view {
    if (_hasMore && [_realDelegate respondsToSelector:@selector(tableViewDidTriggerLoadmore:)]) {
        _loadingMore = [_realDelegate tableViewDidTriggerLoadmore:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_loadingMore) {
            [view loadMoreScrollViewDataSourceDidFinishedLoading:self];
        }
    });
}

#pragma mark delegate forwarding
- (void)reloadData {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super reloadData];
    [CATransaction commit];
}

- (void)layoutSubviews {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super layoutSubviews];
    [CATransaction commit];
    [self setupSectionIndex];
}

- (void)setupSectionIndex {
    if(![self.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])  return;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            obj.FW = 30;
            obj.FR = self.FW;
            [CATransaction commit];
            *stop = YES;
        }
    }];
}

- (void)triggerRefresh {
    if (!_refreshing) {
        if (isRunningOniOS11) {
            #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
            if (@available(iOS 11.0, *)) {
                [self setContentOffset:CGPointMake(0, -self.adjustedContentInset.top-self.contentInset.top) animated:NO];
                [self setContentOffset:CGPointMake(0, -65.0f-self.adjustedContentInset.top-self.contentInset.top-2)];
            }
            #endif
        } else {
            [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:NO];
            [self setContentOffset:CGPointMake(0, -65.0f-self.contentInset.top-2)];
        }
        [_refreshHeaderView setState:TBTPullRefreshPulling];
        [self scrollViewDidEndDragging:self willDecelerate:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_disableTopBounces && self.contentOffset.y < -self.contentInset.top) {
        [self scrollToTopAnimated:NO];
    }
    
    if (_enablePullLoadingMore && self.autoLoadNextPageDistance > 0 && !_loadingMore && _hasMore) {
        CGPoint offset = scrollView.contentOffset;
        CGSize size = scrollView.frame.size;
        CGSize contentSize = scrollView.contentSize;
        
        CGFloat yMargin = offset.y + size.height - contentSize.height;
        if (yMargin>-1*self.autoLoadNextPageDistance && yMargin<0 && offset.y > 0) {
            if ([_realDelegate respondsToSelector:@selector(tableViewDidTriggerLoadmore:)]) {
                _loadingMore = [_realDelegate tableViewDidTriggerLoadmore:self];
                if (_loadingMore) {
                    _loadmoreFooterView.state = LoadMoreLoading;
                }
                return;
            }
        }
    }
    [_loadmoreFooterView setFrame:CGRectMake(0, self.contentSize.height, self.FW, _loadmoreFooterView.FH)];
    
    if (scrollView.contentOffset.y < 0 && !_loadingMore) {
        // 刷新列表
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    } else if (!_loadingMore && _hasMore) {
        [_loadmoreFooterView loadMoreScrollViewDidScroll:self];
    }
    
    if (scrollView == self && (id)_realDelegate != self && [_realDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_realDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(_realDelegate == (id)self) {
        return;
    }
    
    if ([_realDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_realDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(_realDelegate == (id)self) {
        return;
    }
    
    if ([_realDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [_realDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (_hasMore) {
        [_loadmoreFooterView loadMoreScrollViewDidEndDragging:self];
    }
    if (scrollView == self && (id)_realDelegate != self && [_realDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_realDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([UITableView instancesRespondToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [super scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    if ((id)_realDelegate != self && [_realDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_realDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    if ((id)_realDelegate != self) {
        return [_realDelegate respondsToSelector:aSelector];
    }
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ((id)_realDelegate == self) {
        return nil;
    }
    if ([_realDelegate respondsToSelector:aSelector]) {
        return _realDelegate;
    }
    return nil;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [_loadmoreFooterView setFrame:CGRectMake(0, MAX(self.contentSize.height,self.FH), self.FW, _loadmoreFooterView.FH)];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
}

@end
