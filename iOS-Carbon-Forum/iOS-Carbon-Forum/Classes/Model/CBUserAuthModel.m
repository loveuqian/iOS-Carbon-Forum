//
//  CBUserAuthModel.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBUserAuthModel.h"

@implementation CBUserAuthModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_UserCode forKey:@"UserCode"];
    [aCoder encodeObject:_UserExpirationTime forKey:@"UserExpirationTime"];
    [aCoder encodeObject:_UserID forKey:@"UserID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _UserCode = [aDecoder decodeObjectForKey:@"UserCode"];
        _UserExpirationTime = [aDecoder decodeObjectForKey:@"UserExpirationTime"];
        _UserID = [aDecoder decodeObjectForKey:@"UserID"];
    }
    return self;
}

@end
