//
//  NSMutableDictionary+WSFExtension.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "NSMutableDictionary+WSFExtension.h"
#import "CBUserAuthModel.h"

@implementation NSMutableDictionary (WSFExtension)

+ (instancetype)getAPIAuthParams
{
    NSString *sTime = [NSString currentTimeStamp];
    NSString *sValue = [NSString stringWithFormat:@"%@%@%@", sKey, sSecret, sTime];
    NSString *sValueMD5 = [sValue MD5Digest];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:sKey forKey:@"SKey"];
    [mDict setObject:sTime forKey:@"STime"];
    [mDict setObject:sValueMD5 forKey:@"SValue"];

    return mDict;
}

+ (instancetype)getUserAuthParams
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CBUserAuth];
    CBUserAuthModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", model.UserID);

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    //    [mDict setObject:model.UserID forKey:@"AuthUserID"];
    //    [mDict setObject:model.UserExpirationTime forKey:@"AuthUserExpirationTime"];
    //    [mDict setObject:model.UserCode forKey:@"AuthUserCode"];

    return mDict;
}

@end
