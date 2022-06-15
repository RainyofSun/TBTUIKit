//
//  TBTScrollView.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TBTLoadMoreFooterView,TBTRefreshHeaderView,TBTScrollView;

@protocol TBTScrollViewDelegate <UIScrollViewDelegate>

@optional;
- (BOOL)scrollViewDidTriggerRefresh:(TBTScrollView *)scrollView;
- (BOOL)scrollViewDidTriggerLoadmore:(TBTScrollView *)scrollView;

@end

@interface TBTScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, readonly) TBTRefreshHeaderView *refreshHeaderView;
@property (nonatomic, readonly) TBTLoadMoreFooterView *loadmoreFooterView;

@property (nonatomic, assign) BOOL enablePullLoadingMore;
@property (nonatomic, assign) BOOL enablePullRefresh;
@property (nonatomic, assign) UIEdgeInsets defaultContentInset;
@property (nonatomic, assign) CGFloat autoLoadNextPageDistance;

- (void)triggerRefresh;
- (void)didFinishRefreshing;
- (void)didFinishLoadingMore;
- (void)didFinishLoading;
- (void)setHasMore:(BOOL)hasMore;

@end

NS_ASSUME_NONNULL_END
