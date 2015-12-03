//
//  ViewController.m
//  test1203
//
//  Created by WangShengFeng on 15/12/3.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePacker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.datePacker addTarget:self action:@selector(getDate) forControlEvents:UIControlEventValueChanged];
}

- (void)getDate
{
    NSLog(@"%@", self.datePacker.date);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.datePacker.date];
}

@end
