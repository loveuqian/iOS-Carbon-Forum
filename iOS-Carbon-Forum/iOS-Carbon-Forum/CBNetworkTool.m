//
//  CBNetworkTool.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBNetworkTool.h"

@implementation CBNetworkTool

+ (instancetype)shareNetworkTool
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    return instance;
}

@end
