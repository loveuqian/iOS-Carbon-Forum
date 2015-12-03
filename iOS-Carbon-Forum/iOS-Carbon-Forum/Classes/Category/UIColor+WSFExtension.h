//
//  UIColor+WSFExtension.h
//  不得姐
//
//  Created by WangShengFeng on 15/9/2.
//  Copyright © 2015年 WangShengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WSFExtension)

+ (UIColor *)randomColor;

+ (instancetype)colorWithHex:(NSString*)hex andAlpha:(CGFloat)alpha;

@end
