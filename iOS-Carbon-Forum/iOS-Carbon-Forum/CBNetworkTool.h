//
//  CBNetworkTool.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CBNetworkTool : AFHTTPSessionManager

+ (instancetype)shareNetworkTool;

@end
