//
//  TBTSecondViewController.m
//  TBTUIKit_Example
//
//  Created by 刘冉 on 2022/6/14.
//  Copyright © 2022 RainyofSun. All rights reserved.
//

#import "TBTSecondViewController.h"
//#import "UINavigationItem+TBTNavigation.h"

@interface TBTSecondViewController ()

@end

@implementation TBTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
//    self.navigationItem.hideNavigationBar = YES;
}

- (void)cl_popGestureDidEnd {
    NSLog(@"pan end 呼呼呼");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
