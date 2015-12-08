//
//  CBTopicCell.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicListCell.h"
#import "CBTopicListModel.h"
@interface CBTopicListCell ()

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repliesLabel;

@end

@implementation CBTopicListCell

- (void)setModel:(CBTopicListModel *)model
{
    _model = model;

    self.topicLabel.text = model.Topic;
    self.lastTimeLabel.text = [NSString stringWithFormat:@"回复: %@", model.LastTime];
    self.userNameLabel.text = model.UserName;
    self.repliesLabel.text = [NSString stringWithFormat:@"%@回", model.Replies];

    [self layoutSubviews];
}

@end
