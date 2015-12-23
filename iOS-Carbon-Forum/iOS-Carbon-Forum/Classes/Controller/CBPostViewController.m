//
//  CBPostViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/22.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBPostViewController.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface CBPostViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic, weak) UILabel *titlePlaceHolder;
@property (nonatomic, weak) UILabel *contentPlaceHolder;

@property (nonatomic, strong) CBNetworkTool *manager;

@end

@implementation CBPostViewController

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

    self.titleTextView.tintColor = CBCommonColor;
    self.titleTextView.delegate = self;
    self.contentTextView.tintColor = CBCommonColor;
    self.contentTextView.delegate = self;
    [self setupPlaceHolder];
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupNav
{
    self.title = self.titleText;

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"setting_close"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage:[UIImage imageNamed:@"nav_post"] forState:UIControlStateNormal];
    [postButton sizeToFit];
    [postButton addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
}

- (void)closeBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postBtnClick
{
    if (!self.titleTextView.text.length || !self.contentTextView.text.length) {
        // 空判断
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }

    [self.manager.operationQueue cancelAllOperations];

    NSString *urlStr = @"new";
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];
    [params setValuesForKeysWithDictionary:[NSMutableDictionary getUserAuthParams]];
    [params setObject:self.titleTextView.text forKey:@"Title"];
    [params setObject:self.contentTextView.text forKey:@"Tag[]"];
    //    [params setObject:self.contentTextView.text forKey:@"Content"];
    NSLog(@"%@", params);

    WSFWeakSelf;
    [self.manager POST:urlStr
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                <#code to be executed after a specified delay#>
            });
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (void)setupPlaceHolder
{
    UILabel *titlePlaceHolder = [[UILabel alloc] init];
    titlePlaceHolder.text = @"请输入标题";
    titlePlaceHolder.font = [UIFont systemFontOfSize:14];
    titlePlaceHolder.textColor = CBCommonDetailTextColor;
    titlePlaceHolder.frame = CGRectMake(5, 8, 0, 0);
    [titlePlaceHolder sizeToFit];

    self.titlePlaceHolder = titlePlaceHolder;
    [self.titleTextView addSubview:titlePlaceHolder];

    UILabel *contentPlaceHolder = [[UILabel alloc] init];
    contentPlaceHolder.text = @"请输入内容";
    contentPlaceHolder.font = [UIFont systemFontOfSize:14];
    contentPlaceHolder.textColor = CBCommonDetailTextColor;
    contentPlaceHolder.frame = CGRectMake(5, 8, 0, 0);
    [contentPlaceHolder sizeToFit];

    self.contentPlaceHolder = contentPlaceHolder;
    [self.contentTextView addSubview:contentPlaceHolder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.titleTextView) {
        if (textView.text.length) {
            self.titlePlaceHolder.alpha = 0;
        }
        if (!textView.text.length) {
            self.titlePlaceHolder.alpha = 1;
        }
    }

    if (textView == self.contentTextView) {
        if (textView.text.length) {
            self.contentPlaceHolder.alpha = 0;
        }
        if (!textView.text.length) {
            self.contentPlaceHolder.alpha = 1;
        }
    }
}

@end
