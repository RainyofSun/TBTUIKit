//
//  TBTCollectionView.m
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import "TBTCollectionView.h"
#import "TBTLoadMoreFooterView.h"
#import "TBTRefreshHeaderView.h"
#import "MacroHeader.h"
#import "UIView+TBTViewExtension.h"

@interface TBTCollectionView ()<TBTRefreshHeaderDelegate,LoadMoreFooterDelegate>
{
    BOOL _refreshing;
    BOOL _loadingMore;
    BOOL _hasMore;
    
    BOOL _dealloced;
}

@property (nonatomic, weak)id<TBTCollectionViewDelegate> realDelegate;

@end

@implementation TBTCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _defaultContentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return self;
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

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    self.realDelegate = (id<TBTCollectionViewDelegate>)delegate;
    [super setDelegate:nil];
    if (!_dealloced) {
        [super setDelegate:self];
    }
}

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
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(TBTRefreshHeaderView *)view {
    if ([_realDelegate respondsToSelector:@selector(collectionViewDidTriggerRefresh:)]) {
        _refreshing = [_realDelegate collectionViewDidTriggerRefresh:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_refreshing) {
            [view egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        }
    });
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(TBTRefreshHeaderView *)view {
    return _refreshing;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(TBTRefreshHeaderView *)view {
    return [NSDate date];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(TBTLoadMoreFooterView *)view {
    return _loadingMore;
}

- (void)loadMoreTableFooterDidTriggerRefresh:(TBTLoadMoreFooterView *)view {
    if (_hasMore && [_realDelegate respondsToSelector:@selector(collectionViewDidTriggerLoadmore:)]) {
        _loadingMore = [_realDelegate collectionViewDidTriggerLoadmore:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_loadingMore) {
            [view loadMoreScrollViewDataSourceDidFinishedLoading:self];
        }
    });
}

#pragma mark delegate forwarding

- (void)triggerRefresh {
    if (!_refreshing) {
        
        if (isRunningOniOS11) {
            #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
            if (@available(iOS 11.0, *)) {
                [self setContentOffset:CGPointMake(0, -self.adjustedContentInset.top-self.contentInset.top) animated:NO];
                [self setContentOffset:CGPointMake(0, -65.0f-self.adjustedContentInset.top-self.contentInset.top-1)];
            }
            #endif
        } else {
            [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:NO];
            [self setContentOffset:CGPointMake(0, -65.0f-self.contentInset.top-1)];
        }
        [_refreshHeaderView setState:TBTPullRefreshPulling];
        [self scrollViewDidEndDragging:self willDecelerate:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_enablePullLoadingMore && self.autoLoadNextPageDistance > 0 && !_loadingMore && _hasMore) {
        CGPoint offset = scrollView.contentOffset;
        CGSize size = scrollView.frame.size;
        CGSize contentSize = scrollView.contentSize;
        
        CGFloat yMargin = offset.y + size.height - contentSize.height;
        if (yMargin>-1*self.autoLoadNextPageDistance && yMargin<0 && offset.y > 0) {
            if ([_realDelegate respondsToSelector:@selector(collectionViewDidTriggerLoadmore:)]) {
                _loadingMore = [_realDelegate collectionViewDidTriggerLoadmore:self];
                if (_loadingMore) {
                    _loadmoreFooterView.state = LoadMoreLoading;
                }
                return;
            }
        }
    }
    [_loadmoreFooterView setFrame:CGRectMake(0, self.contentSize.height< self.FH? self.FH:self.contentSize.height, self.FW, _loadmoreFooterView.FH)];

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

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_realDelegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [_realDelegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    if ((id)_realDelegate==self) {
        return NO;
    }
    return [_realDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ((id)_realDelegate==self) {
        return nil;
    }
    if ([_realDelegate respondsToSelector:aSelector]) {
        return _realDelegate;
    }
    return nil;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [_loadmoreFooterView setFrame:CGRectMake(0, self.contentSize.height, self.FW, _loadmoreFooterView.FH)];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
}

- (void)dealloc {
    _dealloced = YES;
    NSLog(@"%s",__func__);
}

@end
