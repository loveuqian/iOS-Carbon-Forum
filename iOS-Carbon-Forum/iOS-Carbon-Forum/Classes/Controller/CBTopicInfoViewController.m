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
#import "CBPostModel.h"
#import "CBTopicInfoCell.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <GONMarkupParser_All.h>

@interface CBTopicInfoViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (nonatomic, strong) NSMutableArray *postArr;

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
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)setupNav
{
    self.title = self.model.Topic;
}

- (void)setupTableView
{
    UIImage *img = [UIImage imageNamed:@"CBBackground"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.tableView.backgroundView = imgView;

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.tableView.mj_header =
        [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTopicInfo)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopicInfo)];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CBTopicInfoCell class]) bundle:nil]
         forCellReuseIdentifier:CBTopicInfoCellId];
}

- (void)loadTopicInfo
{
    [self.manager.operationQueue cancelAllOperations];

    self.page = 1;
    NSString *str = [NSString stringWithFormat:@"t/%@-%d", self.model.ID, self.page];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];
    [params addEntriesFromDictionary:[NSMutableDictionary getUserAuthParams]];

    WSFWeakSelf;
    [self.manager GET:str
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            weakSelf.postArr = [CBPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"PostsArray"]];
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
    [params addEntriesFromDictionary:[NSMutableDictionary getUserAuthParams]];

    WSFWeakSelf;
    [self.manager GET:str
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            [weakSelf.postArr
                addObjectsFromArray:[CBPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"PostsArray"]]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CBTopicInfoCellId];
    CBPostModel *model = self.postArr[indexPath.row];
    [cell.textLabel setMarkedUpText:model.Content];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = model.UserName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
