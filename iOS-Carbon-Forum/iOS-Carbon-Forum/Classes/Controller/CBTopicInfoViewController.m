//
//  CBTopicInfoViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicInfoViewController.h"
#import "CBTopicListModel.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface CBTopicInfoViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSArray *topicInfoArr;

@end

@implementation CBTopicInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setupNav
{
}

- (void)setupTableView
{
    self.tableView.mj_header =
        [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTopicInfo)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadTopicInfo
{
    WSFWeakSelf;

    NSString *url = [NSString stringWithFormat:@"http://api.loveuqian.xyz/t/%@-1", self.model.ID];
    
    NSMutableDictionary *dict = [NSMutableDictionary getAPIAuthParams];

    [self.manager GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
