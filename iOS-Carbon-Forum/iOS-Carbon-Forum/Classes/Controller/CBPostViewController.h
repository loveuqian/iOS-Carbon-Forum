//
//  CBPostViewController.h
//  iOS-Carbon-Forum
//
//  Created by WangShengFeng on 15/12/22.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CBNew,
    CBReply,
} CBPostSetting;

@interface CBPostViewController : UIViewController

@property (nonatomic, copy) NSString *titleText;

@property (nonatomic, assign) CBPostSetting *postSetting;

@end
