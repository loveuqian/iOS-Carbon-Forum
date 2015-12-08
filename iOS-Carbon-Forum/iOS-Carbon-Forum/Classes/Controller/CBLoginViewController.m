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
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

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

    [self loadVerifyCode];
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)closeBtnClick:(id)sender
{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];

    NSString *str = @"login";
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];
    [params setObject:self.userNameTextField.text forKey:@"UserName"];
    [params setObject:[self.passwordTextField.text MD5Digest] forKey:@"Password"];
    [params setObject:self.verifyCodeTextField.text forKey:@"VerifyCode"];

    WSFWeakSelf;
    [self.manager POST:str
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            NSNumber *status = responseObject[@"Status"];
            NSLog(@"%@", status);
            if (1 == [status intValue]) {
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
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (IBAction)refreshBtnClick:(id)sender
{
    [self loadVerifyCode];
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

@end
