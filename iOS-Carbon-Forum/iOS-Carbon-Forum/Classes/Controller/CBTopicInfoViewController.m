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

    [self setupTableView];
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
//    WSFWeakSelf;

//    NSString *url = [NSString stringWithFormat:@"https://api.94cb.com/t/%@-1", self.model.ID];

}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.topicInfoArr.count;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    return cell;
//}

@end
