//
//  CBTopicViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicListViewController.h"
#import "CBTopicListModel.h"
#import "CBTopicListCell.h"
#import "CBTopicInfoViewController.h"
#import "CBLoginViewController.h"
#import "CBNetworkTool.h"
#import "CBPostViewController.h"
#import "CBNavigationController.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface CBTopicListViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (nonatomic, strong) NSMutableArray *topicListArr;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIButton *postButton;

@end

@implementation CBTopicListViewController

- (CBNetworkTool *)manager
{
    if (!_manager) {
        _manager = [CBNetworkTool shareNetworkTool];
    }
    return _manager;
}

- (NSMutableArray *)topicListArr
{
    if (!_topicListArr) {
        _topicListArr = [NSMutableArray array];
    }
    return _topicListArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];

    [self setupTableView];

    [self setupPostButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadTopicList];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.postButton.alpha = 1.0;
                     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.postButton.alpha = 0;
                     }];
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)setupNav
{
    self.title = @"Topic List";

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:[UIImage imageNamed:@"setting_personal"] forState:UIControlStateNormal];
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];

    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"setting_refresh"] forState:UIControlStateNormal];
    [refreshButton sizeToFit];
    [refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
}

- (void)loginButtonClick
{
    CBLoginViewController *loginVC = [[CBLoginViewController alloc] init];
    CBNavigationController *navVC = [[CBNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)refreshButtonClick
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTableView
{
    self.tableView.backgroundColor = CBCommonBgColor;

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.mj_header =
        [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTopicList)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopicList)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBTopicListCell class]) bundle:nil]
         forCellReuseIdentifier:CBTopicListCellId];
}

- (void)loadTopicList
{
    [self.manager.operationQueue cancelAllOperations];

    self.page = 1;
    NSString *urlStr = [NSString stringWithFormat:@"page/%d", self.page];
    
    WSFWeakSelf;
    [self.manager GET:urlStr
        parameters:[NSMutableDictionary getAPIAuthParams]
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            weakSelf.topicListArr = [CBTopicListModel mj_objectArrayWithKeyValuesArray:responseObject[@"TopicsArray"]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
}

- (void)loadMoreTopicList
{
    [self.manager.operationQueue cancelAllOperations];

    ++self.page;
    NSString *urlStr = [NSString stringWithFormat:@"page/%d", self.page];
    WSFWeakSelf;
    [self.manager GET:urlStr
        parameters:[NSMutableDictionary getAPIAuthParams]
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            NSArray *newArr = [CBTopicListModel mj_objectArrayWithKeyValuesArray:responseObject[@"TopicsArray"]];
            [weakSelf.topicListArr addObjectsFromArray:newArr];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
}

- (void)setupPostButton
{
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setBackgroundImage:[UIImage imageNamed:@"create_new"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [postButton sizeToFit];
    CGFloat margin = postButton.width;
    postButton.frame = CGRectMake(mainScreenWidth - margin, mainScreenHeight - margin, 0, 0);
    [postButton sizeToFit];

    self.postButton = postButton;
    [[UIApplication sharedApplication].keyWindow addSubview:postButton];
}

- (void)postBtnClick
{
    CBPostViewController *postVC = [[CBPostViewController alloc] init];
    postVC.titleText = @"New";
    postVC.postSetting = CBNew;
    CBNavigationController *navVC = [[CBNavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:CBTopicListCellId];
    cell.model = self.topicListArr[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CBTopicListModel *model = self.topicListArr[indexPath.row];
    CBTopicInfoViewController *infoVC = [[CBTopicInfoViewController alloc] init];
    infoVC.model = model;

    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
