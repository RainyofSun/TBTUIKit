//
//  TBTCollectionView.h
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TBTCollectionView,TBTLoadMoreFooterView,TBTRefreshHeaderView;

@protocol TBTCollectionViewDelegate <UICollectionViewDelegate>

@optional;
- (BOOL)collectionViewDidTriggerRefresh:(TBTCollectionView *)collectionView;
- (BOOL)collectionViewDidTriggerLoadmore:(TBTCollectionView *)collectionView;

@end

@interface TBTCollectionView : UICollectionView<UICollectionViewDelegate>

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
