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

@interface CBLoginViewController ()

@property (nonatomic, strong) CBNetworkTool *manager;

@property (weak, nonatomic) IBOutlet UIImageView *verifyCodeImageView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

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

    NSString *urlStr = [NSString stringWithFormat:@"%@seccode.php", baseUrl];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                self.verifyCodeImageView.image = [UIImage imageWithData:data];
                                            });
                                        }];
    [task resume];
}

- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
}

- (IBAction)closeBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtnClick:(UIButton *)sender
{
    if (!self.verifyCodeTextField.text) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    NSString *str = @"login";
    NSMutableDictionary *params = [NSMutableDictionary getAPIAuthParams];
    [params setObject:@"loveuqian" forKey:@"UserName"];
    [params setObject:[@"asdfghjkl" MD5Digest] forKey:@"Password"];
    [params setObject:self.verifyCodeTextField.text forKey:@"VerifyCode"];

    WSFWeakSelf;
    [self.manager POST:str
        parameters:params
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject) {
            CBUserAuthModel *model = [CBUserAuthModel mj_objectWithKeyValues:responseObject];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:CBUserAuth];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error);
        }];
}

@end
