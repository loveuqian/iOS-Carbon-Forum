//
//  CBTopicModel.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTopicListModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *LastName;

@property (nonatomic, copy) NSString *LastTime;

@property (nonatomic, copy) NSString *Replies;

@property (nonatomic, copy) NSString *Tags;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *UserName;

@end
