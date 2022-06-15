//
//  TBTRefreshHeaderView.h
//  Pods
//
//  Created by 刘冉 on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    TBTPullRefreshPulling = 0,
    TBTPullRefreshNormal,
    TBTPullRefreshLoading,
} TBTPullRefreshState;

@class TBTRefreshHeaderView,TBTRefreshActivityAnimationView;
@protocol TBTRefreshHeaderDelegate <NSObject>

- (void)egoRefreshTableHeaderDidTriggerRefresh:(TBTRefreshHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(TBTRefreshHeaderView*)view;

@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(TBTRefreshHeaderView*)view;

@end

@protocol TBTRefreshHeaderAnimator <NSObject>

- (void)egoRefreshStateChanged:(TBTPullRefreshState)state;

@end

@interface TBTRefreshHeaderView : UIView
{
    TBTPullRefreshState _state;
    CGFloat _defaultContentInset;
}

@property(nonatomic, strong) TBTRefreshActivityAnimationView *loadingView;
@property(nonatomic, weak) id<TBTRefreshHeaderDelegate> delegate;
@property(nonatomic, assign)CGFloat defaultContentInset;
@property(nonatomic, assign)CGFloat ios11ContentInsetTop;
@property(nonatomic, weak) id<TBTRefreshHeaderAnimator> customAnimator;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setState:(TBTPullRefreshState)aState;

@end

NS_ASSUME_NONNULL_END
