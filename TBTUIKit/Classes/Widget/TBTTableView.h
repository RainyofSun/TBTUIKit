//
//  TBTTableView.h
//  Pods
//
//  Created by 刘冉 on 2022/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TBTTableView,TBTLoadMoreFooterView,TBTRefreshHeaderView;

@protocol TBTTableViewData <NSObject>

- (Class)tableViewCellClassForTableView:(TBTTableView *)tableView;
@optional
- (CGFloat)tableViewCellHeightForCellClass:(Class)cellClass;
- (CGFloat)tableViewCellHeightForTableView:(TBTTableView *)tableView;

@end

@protocol  KKTableViewDataSource <UITableViewDataSource>

@optional
- (id<TBTTableViewData>)tableView:(TBTTableView *)tableView dataForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TBTTableViewDelegate <UITableViewDelegate>

@optional;
- (BOOL)tableViewDidTriggerRefresh:(TBTTableView *)taleView;
- (BOOL)tableViewDidTriggerLoadmore:(TBTTableView *)taleView;

@end

@interface TBTTableView : UITableView<UITableViewDelegate>

@property (nonatomic, retain)id userInfo;
@property (nonatomic, readonly) TBTRefreshHeaderView *refreshHeaderView;
@property (nonatomic, readonly) TBTLoadMoreFooterView *loadmoreFooterView;
@property (nonatomic, assign) BOOL enablePullLoadingMore;
@property (nonatomic, assign) BOOL enablePullRefresh;
@property (nonatomic, assign) UIEdgeInsets defaultContentInset;
@property (nonatomic, assign) CGFloat autoLoadNextPageDistance;
@property (nonatomic, assign) BOOL disableTopBounces;
@property (nonatomic, strong) UILabel *emptyLabel;

/**
 点击cell时是否允许重置所有visibleCell的select和highited状态，default YES
 */
@property (nonatomic, assign) BOOL allowResetSelectedAndHighitedStatus;

- (void)triggerRefresh;
- (void)didFinishRefreshing;
- (void)didFinishLoadingMore;
- (void)didFinishLoading;
- (void)setHasMore:(BOOL)hasMore;
- (BOOL)hasMore;
- (void)restartRefreshAnimationIfNeed;

@end

NS_ASSUME_NONNULL_END
