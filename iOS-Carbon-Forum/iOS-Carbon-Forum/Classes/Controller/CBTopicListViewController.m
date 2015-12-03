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

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface CBTopicListViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSArray *topicListArr;

@end

@implementation CBTopicListViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];
    [self setupTableView];
}

- (void)setupNav
{
    self.title = @"主题";
    
    self.navigationItem.leftBarButtonItem.title = @"123";
}

- (void)setupTableView
{
    UIImage *img = [UIImage imageNamed:@"CBBackground"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.tableView.backgroundView = imgView;
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.mj_header =
        [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTopicList)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadTopicList
{
    NSString *str = @"http://api.loveuqian.xyz/page/1";

    WSFWeakSelf;
    [self.manager GET:str
        parameters:[NSMutableDictionary getAPIAuthParams]
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            weakSelf.topicListArr = [CBTopicListModel mj_objectArrayWithKeyValuesArray:responseObject[@"TopicsArray"]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    
    [self.manager GET:str
           parameters:[NSMutableDictionary getAPIAuthParams]
              success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                  weakSelf.topicListArr = [CBTopicListModel mj_objectArrayWithKeyValuesArray:responseObject[@"TopicsArray"]];
                  [weakSelf.tableView reloadData];
                  [weakSelf.tableView.mj_header endRefreshing];
              }
              failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                  [weakSelf.tableView.mj_header endRefreshing];
              }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTopicListCell *cell = [[CBTopicListCell alloc] init];
    CBTopicListModel *model = self.topicListArr[indexPath.row];
    cell.textLabel.text = model.Topic;
    cell.textLabel.numberOfLines = 0;

    return cell;
}

@end
