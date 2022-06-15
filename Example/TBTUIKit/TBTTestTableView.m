//
//  TBTTestTableView.m
//  TBTUIKit_Example
//
//  Created by 刘冉 on 2022/6/15.
//  Copyright © 2022 RainyofSun. All rights reserved.
//

#import "TBTTestTableView.h"
#import "TBTTableView.h"

@interface TBTTestTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
}
@property (nonatomic,strong) TBTTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation TBTTestTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.purpleColor;
        page = 0;
        [self setupUI];
        [_tableView triggerRefresh];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (BOOL)tableViewDidTriggerRefresh:(TBTTableView *)taleView {
    [self localData:YES];
    return YES;
}

- (BOOL)tableViewDidTriggerLoadmore:(TBTTableView *)taleView {
    [self localData:NO];
    return (page == 5);
}

- (void)localData:(BOOL)isRefresh {
    if (isRefresh) {
        [self.dataSource removeAllObjects];
        NSLog(@"刷新数据");
    } else {
        if (page >= 5) {
            NSLog(@"没有更多了");
            return;
        }
    }
    for (int i = 0; i < 20; i ++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%u",arc4random()%100]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isRefresh) {
            [_tableView didFinishRefreshing];
            page = 0;
        } else {
            [_tableView didFinishLoading];
            page ++;
        }
        [_tableView reloadData];
        [_tableView setHasMore:(page != 5)];
    });
}

#pragma mark - lazy
- (TBTTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TBTTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.enablePullRefresh = YES;
        _tableView.enablePullLoadingMore = YES;
        _tableView.autoLoadNextPageDistance = 600;
        _tableView.contentInset = UIEdgeInsetsZero;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
