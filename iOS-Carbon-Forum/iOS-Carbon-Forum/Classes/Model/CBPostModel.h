//
//  CBPostModel.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPostModel : NSObject

@property (nonatomic, copy) NSString *Content;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *IsDel;

@property (nonatomic, copy) NSString *PostFloor;

@property (nonatomic, copy) NSString *PostTime;

@property (nonatomic, copy) NSString *TopicID;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *UserName;

@end
