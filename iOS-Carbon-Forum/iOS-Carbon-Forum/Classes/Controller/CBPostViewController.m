//
//  CBPostViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/22.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBPostViewController.h"

@interface CBPostViewController ()

@end

@implementation CBPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNav];
}

- (void)setupNav
{
    self.title = @"Post";

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"setting_close"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
