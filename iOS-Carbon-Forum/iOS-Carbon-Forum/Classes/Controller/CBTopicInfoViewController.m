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

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface CBTopicInfoViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (nonatomic, strong) NSMutableArray *topicInfoArr;

@property (nonatomic, assign) int page;

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

    [self.navigationController.navigationBar setBarTintColor:CBCommonBgColor];
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

- (void)loadTopicInfo
{
    [self.manager.operationQueue cancelAllOperations];

    self.page = 1;
    NSString *str = [NSString stringWithFormat:@"t/%@-%d", self.model.ID, self.page];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];

    WSFWeakSelf;
    [self.manager GET:str
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
    NSString *str = [NSString stringWithFormat:@"t/%@-%d", self.model.ID, self.page];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];

    WSFWeakSelf;
    [self.manager GET:str
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.model.Topic;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.text = self.model.Topic;
//    label.numberOfLines = 0;
//    label.backgroundColor = CBCommonBgColor;
//    return label;
//}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44.0;
//}

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
