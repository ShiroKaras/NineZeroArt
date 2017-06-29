//
//  HTLoginButton.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/24.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTLoginButton.h"
#import "CommonUI.h"
#import "CommonDefine.h"

@implementation HTLoginButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == YES) {
        self.titleLabel.textColor = [UIColor whiteColor];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        [self setBackgroundImage:[self imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:COMMON_PINK_COLOR] forState:UIControlStateHighlighted];
    } else {
        self.backgroundColor = [UIColor colorWithHex:0x0a3e32];
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.28];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.28] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.28] forState:UIControlStateDisabled];
    }
}

- (void)showNextTipImage:(BOOL)show {
    if (show == YES) {
        self.titleLabel.text = @"";
        [self setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
