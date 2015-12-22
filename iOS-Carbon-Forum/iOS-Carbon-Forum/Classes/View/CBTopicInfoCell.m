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
    
    NSTimeInterval time = [model.PostTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    self.postTimeLabel.text = [NSString stringWithFormat:@"%@", destDateString];
    
    self.userNameLabel.text = model.UserName;
}

@end
