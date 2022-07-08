//
//  TBTTabBarController.m
//  TBT
//
//  Created by 刘冉 on 2022/6/9.
//

#import "TBTTabBarController.h"
#import <objc/runtime.h>

@interface UIViewController (TBTTabBarControllerItemInternal)

- (void)tbt_setTabBarController:(TBTTabBarController *)tabBarController;

@end

@implementation UIViewController (TBTTabBarControllerItemInternal)

- (void)tbt_setTabBarController:(TBTTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(tbt_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface TBTTabBarController ()<TBTTabBarDelegate>
{
    UIView *_contentView;
}

@property (nonatomic,readwrite) TBTTabBar *tabBar;

@end

@implementation TBTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSelectedIndex:[self selectedIndex]];
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods
- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[self tabBar].items[selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[self contentView].bounds];
    [[self contentView] addSubview:[self selectedViewController].view];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        NSMutableArray *tabbarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            TBTTabBarItem *tabbarItem = [[TBTTabBarItem alloc] init];
            [tabbarItem setTitle:viewController.title];
            [tabbarItems addObject:tabbarItem];
            [viewController tbt_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabbarItems];
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController tbt_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated {
    _tabBarHidden = tabBarHidden;
    
    __weak TBTTabBarController *weakSelf = self;
    
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStaringY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([weakSelf tabBar].frame);
        CGFloat bottomSafeHeight = [weakSelf getBottomSafeHeight];
        
        if (!tabBarHeight) {
            tabBarHeight = 49 + bottomSafeHeight;
        }
        
        if (!tabBarHidden) {
            tabBarStaringY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStaringY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (tabBarHidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)tabBarHidden {
    [self setTabBarHidden:tabBarHidden animated:NO];
}

#pragma mark - TBTTabBarDelegate
- (BOOL)tabBar:(TBTTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:self.viewControllers[index]]) {
            return NO;
        }
    }
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            if (selectedController.topViewController != selectedController.viewControllers.firstObject) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        return NO;
    }
    return YES;
}

- (void)tabBar:(TBTTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [self viewControllers].count) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (CGFloat)getBottomSafeHeight {
    if ([UIScreen mainScreen].bounds.size.height > 812.0) {
        return 34.f;
    }
    return 0;
}

- (TBTTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TBTTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleBottomMargin)];
        _tabBar.contentEdgeInsets = UIEdgeInsetsMake(0, 0, [self getBottomSafeHeight], 0);
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

@end

@implementation UIViewController (TBTTabBarControllerItem)

- (TBTTabBarController *)tbt_tabBarController {
    TBTTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(tbt_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController tbt_tabBarController];
    }
    return tabBarController;
}

- (TBTTabBarItem *)tbt_tabBarItem {
    TBTTabBarController *tabBarController = [self tbt_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[tabBarController tabBar].items objectAtIndex:index];
}

- (void)tbt_setTabBarItem:(TBTTabBarItem *)tbt_tabBarItem {
    TBTTabBarController *tabBarController = [self tbt_tabBarController];
    if (!tabBarController) {
        return;
    }
    
    TBTTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:tabBar.items];
    [tabBarItems replaceObjectAtIndex:index withObject:tbt_tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
