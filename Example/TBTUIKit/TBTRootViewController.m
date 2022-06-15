//
//  TBTRootViewController.m
//  TBTUIKit_Example
//
//  Created by 刘冉 on 2022/6/14.
//  Copyright © 2022 RainyofSun. All rights reserved.
//

#import "TBTRootViewController.h"
#import "TBTSecondViewController.h"
#import "TBTTestTableView.h"

@interface TBTRootViewController ()

@property (nonatomic,strong) TBTTestTableView *testView;

@end

@implementation TBTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.testView];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.navigationController pushViewController:[[TBTSecondViewController alloc] init] animated:YES];
//}

- (TBTTestTableView *)testView {
    if (!_testView) {
        _testView = [[TBTTestTableView alloc] initWithFrame:self.view.bounds];
    }
    return _testView;
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
