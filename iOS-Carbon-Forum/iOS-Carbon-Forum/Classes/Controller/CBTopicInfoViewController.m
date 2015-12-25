//
//  CBTopicInfoViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicInfoViewController.h"
#import "CBTopicListModel.h"
#import "CBNetworkTool.h"
#import "CBTopicInfoModel.h"
#import "CBTopicInfoCell.h"
#import "CBTopicListCell.h"
#import "CBPostViewController.h"
#import "CBNavigationController.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface CBTopicInfoViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (nonatomic, strong) NSMutableArray *topicInfoArr;

@property (nonatomic, assign) int page;

@property (nonatomic, weak) UIButton *postButton;

@end

@implementation CBTopicInfoViewController

- (CBNetworkTool *)manager
{
    if (!_manager) {
        _manager = [CBNetworkTool shareNetworkTool];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];

    [self setupTableView];

    [self setupTitle];

    [self setupPostButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadTopicInfo];

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
    self.title = @"Topic Info";

    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"setting_refresh"] forState:UIControlStateNormal];
    [refreshButton sizeToFit];
    [refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
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
        [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTopicInfo)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopicInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBTopicInfoCell class]) bundle:nil]
         forCellReuseIdentifier:CBTopicInfoCellId];
}

- (void)loadTopicInfo
{
    [self.manager.operationQueue cancelAllOperations];

    self.page = 1;
    NSString *urlStr = [NSString stringWithFormat:@"t/%@-%d", self.model.ID, self.page];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];

    WSFWeakSelf;
    [self.manager GET:urlStr
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            weakSelf.topicInfoArr = [CBTopicInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"PostsArray"]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
}

- (void)loadMoreTopicInfo
{
    [self.manager.operationQueue cancelAllOperations];

    ++self.page;
    NSString *urlStr = [NSString stringWithFormat:@"t/%@-%d", self.model.ID, self.page];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];

    WSFWeakSelf;
    [self.manager GET:urlStr
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            [weakSelf.topicInfoArr
                addObjectsFromArray:[CBTopicInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"PostsArray"]]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.tableView.mj_footer.hidden = YES;
        }];
}

- (void)setupTitle
{
    CGFloat margin = 10;

    UILabel *label = [[UILabel alloc] init];
    label.text = self.model.Topic;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    CGFloat textH = [self.model.Topic boundingRectWithSize:CGSizeMake(mainScreenWidth, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                } context:nil].size.height;
    label.frame = CGRectMake(margin, margin, mainScreenWidth - 2 * margin, textH);

    UIView *view = [[UIView alloc] init];
    view.height = textH + 2 * margin;
    view.backgroundColor = CBCommonColor;
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
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
    postVC.titleText = @"Reply";
    postVC.postSetting = CBReply;
    postVC.TopicID = self.model.ID;
    CBNavigationController *navVC = [[CBNavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTopicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CBTopicInfoCellId];
    CBTopicInfoModel *model = self.topicInfoArr[indexPath.row];
    cell.model = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
