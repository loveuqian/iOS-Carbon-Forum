//
//  CBUserAuthModel.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUserAuthModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *UserCode;

@property (nonatomic, copy) NSString *UserExpirationTime;

@property (nonatomic, copy) NSString *UserID;

@end
