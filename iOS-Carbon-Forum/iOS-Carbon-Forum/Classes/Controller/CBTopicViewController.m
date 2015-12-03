//
//  CBTopicViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicViewController.h"

#import <AFNetworking.h>

@interface CBTopicViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation CBTopicViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *img = [UIImage imageNamed:@"CBBackground"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    self.tableView.backgroundView = imgView;

    [self.manager GET:nil
        parameters:nil
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
        }];
}

@end
