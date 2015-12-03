//
//  MJExtensionMapConfig.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "MJExtensionMapConfig.h"
#import "CBTopicListModel.h"

#import <MJExtension.h>

@implementation MJExtensionMapConfig

+ (void)load
{
    [CBTopicListModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
            @"ID" : @"id",
        };
    }];
}

@end
