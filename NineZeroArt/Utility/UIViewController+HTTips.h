//
//  UIViewController+HTTips.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/19.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HTTips)

- (void)showTipsWithText:(NSString *)text;
- (void)showTipsWithText:(NSString *)text color:(UIColor *)color;
- (void)showTipsWithText:(NSString *)text offset:(NSInteger)offset;

@end
