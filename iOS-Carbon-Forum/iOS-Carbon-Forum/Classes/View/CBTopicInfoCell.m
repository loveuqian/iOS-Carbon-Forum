//
//  CBTopicInfoCell.m
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/4.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "CBTopicInfoCell.h"
#import "CBTopicInfoModel.h"

@interface CBTopicInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation CBTopicInfoCell

- (void)setModel:(CBTopicInfoModel *)model
{
    _model = model;
    
    self.contentLabel.text = model.Content;
    self.postTimeLabel.text = model.PostTime;
    self.userNameLabel.text = model.UserName;
}

@end
