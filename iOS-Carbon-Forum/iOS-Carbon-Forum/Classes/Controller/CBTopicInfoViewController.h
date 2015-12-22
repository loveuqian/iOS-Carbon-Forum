//
//  CBTopicInfoViewController.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTopicListModel;

@interface CBTopicInfoViewController : UITableViewController

@property (nonatomic, strong) CBTopicListModel *model;

@property (nonatomic, assign) CGFloat headerViewHeight;

@end
