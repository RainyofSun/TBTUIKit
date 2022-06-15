//
//  TBTLoadMoreFooterView.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    LoadMorePulling = 0,
    LoadMoreNormal,
    LoadMoreLoading,
    LoadMoreNone,
} LoadMoreState;

@class TBTLoadMoreFooterView;
@protocol LoadMoreFooterDelegate<NSObject>

- (void)loadMoreTableFooterDidTriggerRefresh:(TBTLoadMoreFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(TBTLoadMoreFooterView *)view;

@end

@interface TBTLoadMoreFooterView : UIView
{
    LoadMoreState _state;
    
    UILabel *_statusLabel;
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic, weak) id <LoadMoreFooterDelegate> delegate;
@property(nonatomic, strong) NSString *loadingTip;
@property(nonatomic, assign) LoadMoreState state;
@property(nonatomic, assign) CGFloat defaultContentInset;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
