//
//  CBLoginViewController.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBLoginViewController.h"
#import "CBUserAuthModel.h"
#import "CBNetworkTool.h"
#import "CBUserAuthModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface CBLoginViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeImageView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (nonatomic, assign, getter=isLogin) BOOL login;
@property (nonatomic, strong) NSArray *userAuthArr;

@end

@implementation CBLoginViewController

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

    self.login = YES;
    self.emailTextField.enabled = NO;
    [self loadVerifyCode];
    [self setupNav];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.userNameTextField becomeFirstResponder];
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loadVerifyCode
{
    self.loginBtn.userInteractionEnabled = NO;

    NSString *urlStr = [NSString stringWithFormat:@"%@seccode.php", baseUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                self.verifyCodeImageView.image = [UIImage imageWithData:data];
                                                self.loginBtn.userInteractionEnabled = YES;
                                            });
                                        }];
    [task resume];
}

- (void)setupNav
{
    self.title = @"Login";

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:[UIImage imageNamed:@"setting_close"] forState:UIControlStateNormal];
    [loginButton sizeToFit];
    [loginButton addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];

    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"setting_refresh"] forState:UIControlStateNormal];
    [refreshButton sizeToFit];
    [refreshButton addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
}

- (void)closeBtnClick
{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshBtnClick
{
    [self loadVerifyCode];
}

- (IBAction)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];
    [params setObject:self.userNameTextField.text forKey:@"UserName"];
    [params setObject:[self.passwordTextField.text MD5Digest] forKey:@"Password"];
    [params setObject:self.verifyCodeTextField.text forKey:@"VerifyCode"];

    WSFWeakSelf;
    if (self.isLogin) {
        // 登录
        NSString *url = @"login";

        [self.manager POST:url
            parameters:params
            success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                if (!responseObject[@"ErrorCode"]) {
                    CBUserAuthModel *model = [CBUserAuthModel mj_objectWithKeyValues:responseObject];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CBUserAuth];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    dispatch_after(
                        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        });
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                    [weakSelf loadVerifyCode];
                    self.verifyCodeTextField.text = @"";
                    NSLog(@"%@", responseObject);
                }
            }
            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"%@", error);

            }];
    }

    if (!self.isLogin) {
        // 注册
        NSString *url = @"register";
        [params setObject:self.emailTextField.text forKey:@"Email"];

        [self.manager POST:url
            parameters:params
            success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
                if (!responseObject[@"ErrorCode"]) {
                    [SVProgressHUD showSuccessWithStatus:@"注册成功\n请重新登录"];
                    [weakSelf loadVerifyCode];
                    [self registerBtnClick:self.accountBtn];
                    self.verifyCodeTextField.text = @"";
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"注册失败\n请重新输入"];
                    [weakSelf loadVerifyCode];
                    self.verifyCodeTextField.text = @"";
                    NSLog(@"%@", responseObject);
                }
            }
            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"%@", error);
            }];
    }
}

- (IBAction)registerBtnClick:(id)sender
{
    self.login = !self.isLogin;

    if (self.isLogin) {
        // 登录
        [self.loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
        [sender setTitle:@"没有账号" forState:UIControlStateNormal];
        self.emailTextField.placeholder = @"登录无需输入邮箱";
        self.emailTextField.enabled = NO;
    }
    if (!self.isLogin) {
        // 注册
        [self.loginBtn setTitle:@"注  册" forState:UIControlStateNormal];
        [sender setTitle:@"已有账号" forState:UIControlStateNormal];
        self.emailTextField.placeholder = @"注册需要输入邮箱";
        self.emailTextField.enabled = YES;
    }
}


@end
