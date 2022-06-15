//
//  TBTRefreshActivityAnimationView.h
//  TBTUIKit
//
//  Created by 刘冉 on 2022/6/15.
//

#import "TBTBaseRefreshHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBTRefreshActivityAnimationView : TBTBaseRefreshHeaderView

- (void)stopAnimations;
- (void)startAnimations;
- (void)setStatusLabText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
