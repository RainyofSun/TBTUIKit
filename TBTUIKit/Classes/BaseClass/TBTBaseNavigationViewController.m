//
//  TBTBaseNavigationViewController.m
//  Pods
//
//  Created by 刘冉 on 2022/6/13.
//

#import "TBTBaseNavigationViewController.h"
#import "UINavigationItem+TBTNavigation.h"
#import "TBTUIKit/TBTUIFont.h"
#import "UIDevice+Utilities.h"

/// Whether to use system pop gesture. If NO, full-screen pop gesture will be set.
static const BOOL useSystemGesture = NO;
/// Whether to enable global pop gestures. The defaut is YES.
static const BOOL popGestureEnabled = YES;

@interface TBTBaseNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary <NSString *,NSNumber *>*vcsDic;
}

@end

@implementation TBTBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureNavigationBar];
    [self configureNavigationGestures];
}

- (void)configureNavigationBar {
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.blackColor,
                                          NSFontAttributeName:[TBTUIFont getFontWithStyle:TBTFontStyle_Large isBold:NO]
    };
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *nba = [[UINavigationBarAppearance alloc] init];
        [nba configureWithOpaqueBackground];
        nba.backgroundColor = UIColor.whiteColor;
        // hide bottom line
        nba.shadowColor = UIColor.clearColor;
        nba.titleTextAttributes = titleTextAttributes;
        self.navigationBar.standardAppearance = nba;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
    } else {
        self.navigationBar.titleTextAttributes = titleTextAttributes;
        self.navigationBar.tintColor = UIColor.whiteColor;
        [self.navigationBar setValue:@1 forKey:@"hidesShadow"];
    }
    self.navigationBar.translucent = NO;
}

- (void)configureNavigationGestures {
    vcsDic = @{}.mutableCopy;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL transitionSel = @selector(handleNavigationTransition:);
#pragma clang diagnostic pop
    
    id target = self.interactivePopGestureRecognizer.delegate;
    if (useSystemGesture && [self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    } else if ([target respondsToSelector:transitionSel]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:transitionSel];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        self.delegate = self;
    }
}

#pragma mark - override super methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = popGestureEnabled;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count == 1) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0 || fabs(translation.x) < fabs(translation.y)) {
        return NO;
    }
    
    UIViewController *topViewController = self.viewControllers.lastObject;
    //超出响应区域
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (location.x >= topViewController.navigationItem.popEffectiveWidth) {
        return NO;
    }
    NSString *key = [self vcKeyFromVC:self.topViewController];
    if (key && vcsDic[key] != nil) {
        return [vcsDic[key] boolValue];
    }
    return self.interactivePopGestureRecognizer.isEnabled;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            return;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL sel = @selector(cl_popGestureDidEnd);
#pragma clang diagnostic pop
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        if (fromVC && [fromVC respondsToSelector:sel]) {
            IMP imp = [fromVC methodForSelector:sel];
            void (*func)(id,SEL) = (void *)imp;
            func(fromVC,sel);
        }
    }];
    if (viewController.navigationItem.hideNavigationBar != self.navigationBarHidden) {
        if (viewController.navigationItem.hideNavigationBar) {
            [navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSString *vcKey = [self vcKeyFromVC:viewController];
    if (vcKey && vcsDic[vcKey] == nil) {
        // Saves each pop gesture enabled value if it's set for child view controller.
        vcsDic[vcKey] = @(self.interactivePopGestureRecognizer.isEnabled);
    }
    BOOL  hideNavigationBarOnSwipe = viewController.navigationItem.hideNavigationBarOnSwipe;
    [self setHidesBarsOnSwipe:hideNavigationBarOnSwipe];
}

#pragma mark - Convenience methods
- (nullable NSString *)vcKeyFromVC:(UIViewController *)viewController {
    return NSStringFromClass([viewController class]);
}

- (void)setSpecifiedViewControllerInteractivePopGestureEnabled:(BOOL)enabled {
    NSString *vcKey = [self vcKeyFromVC:self.topViewController];
    if (vcKey) {
        vcsDic[vcKey] = @(enabled);
    }
}

@end
