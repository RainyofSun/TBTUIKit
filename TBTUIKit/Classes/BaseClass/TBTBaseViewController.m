//
//  TBTBaseViewController.m
//  Pods
//
//  Created by 刘冉 on 2022/6/13.
//

#import "TBTBaseViewController.h"
#import "UINavigationItem+TBTNavigation.h"
#import "UIImage+TBTBundleImage.h"
#import "TBTUIImageExtension.h"
#import "MacroHeader.h"

@interface TBTBaseViewController ()
{
    UIImageView *_navBarHairlineImageView;
}
@end

@implementation TBTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //prevent view move down
    self.automaticallyAdjustsScrollViewInsets = NO;
    //set view backgroundColor
    self.view.backgroundColor = [UIColor whiteColor];
    //wipe out the black line under the navigation bar
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    _navBarHairlineImageView = [self slnFindHairlineImageViewUnder:navigationBar];
    self.navigationItem.popEffectiveWidth = kScreenWidth;
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.navigationController.presentedViewController == nil) {
        if (isRunningOniOS11) {
            [self.navigationController setNavigationBarHidden:self.navigationItem.hideNavigationBar animated:NO];
        } else {
            [self.navigationController setNavigationBarHidden:self.navigationItem.hideNavigationBar animated:animated];
        }
    }
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
    self.navigationController.navigationBar.barStyle =UIBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.navigationController.presentedViewController == nil) {
        if (!self.navigationController.isNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        }
    }
    [super viewWillDisappear:animated];
}

#pragma mark ------- set nav left item
-(void)createBackBtnWithImageName:(NSString *)imageName{
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_back.frame = CGRectMake(0, 0, 40, 30);
    btn_back.contentEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    btn_back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn_back setImage:[UIImage tbt_imgWithName:imageName] forState:UIControlStateNormal];
    //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
    [btn_back addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [btn_back addTarget:self action:@selector(cl_leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn_back];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)cl_leftBarButtonClicked {
    if (self.navigationController.viewControllers.count == 0) {
        return;
    }
    [self cl_popVC];
}

#pragma mark ------- wipe out button highlight
-(void)preventFlicker:(UIButton *)sender{
    sender.highlighted = NO;
}

#pragma mark ------- set nav right item
-(void)createNavRightBtnWithImageName:(NSString *)imageName {
    UIButton *btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_right.frame = CGRectMake(0, 0, 40, 30);
    btn_right.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    btn_right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn_right setImage:[UIImage tbt_imgWithName:imageName] forState:UIControlStateNormal];
    btn_right.tag = 10;
    //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
    [btn_right addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [btn_right addTarget:self action:@selector(cl_rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn_right];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)cl_rightBarButtonClicked {
    if (self.navigationController.viewControllers.count == 0) {
        return;
    }
    [self cl_popVC];
}

/**
 * @brief NOTE: please override this method in your child view controller. Don't remove this method because it may be called if necessary.
*/
- (void)cl_popGestureDidEnd {
    // Attention! Override this method in child view controller.
}

- (void)setCl_interactivePopGestureEnabled:(BOOL)cl_interactivePopGestureEnabled {
    _cl_interactivePopGestureEnabled = cl_interactivePopGestureEnabled;
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic push
    SEL sel = @selector(setSpecifiedViewControllerInteractivePopGestureEnabled:);
#pragma clang diagnostic pop
    if (self.navigationController && [self.navigationController respondsToSelector:sel]) {
        IMP imp = [self.navigationController methodForSelector:sel];
        void(*func)(id, SEL, BOOL) = (void *)imp;
        func(self.navigationController, sel, cl_interactivePopGestureEnabled);
    }
}

#pragma mark ------- get nav bottom black line
-(UIImageView *)slnFindHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0){
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self slnFindHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - Category
- (void)cl_popVC {
    [self.class cl_popVCFrom:self];
}

+ (void)cl_popVCFrom:(UIViewController *)viewController {
    
    UINavigationController *nav;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)viewController;
    } else {
        // nav may be nil here.
        nav = viewController.navigationController;
    }
    
    if (!nav) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIViewController *topVC = nav.topViewController;
    
    // Dismiss all the being presented view controllers.
    while (topVC.presentedViewController) {
        [topVC.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIViewController *vc = [nav popViewControllerAnimated:YES];
    // Dismiss the root view controller if topVC is the last presented view controller.
    if (!vc) {
        [topVC dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
