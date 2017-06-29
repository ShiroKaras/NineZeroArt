//
//  Utility.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/19.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HUD+Utility.h"
#import <MBProgressHUD+BWMExtension.h>

@implementation MBProgressHUD (Utility)

+ (void)showSuccessWithTitle:(NSString *)title {
    [MBProgressHUD bwm_showTitle:title toView:[[[UIApplication sharedApplication] delegate] window] hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
}

+ (void)showErrorWithTitle:(NSString *)title {
    [MBProgressHUD bwm_showTitle:title toView:[[[UIApplication sharedApplication] delegate] window] hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
}

+ (void)showWarningWithTitle:(NSString *)title {
    [MBProgressHUD bwm_showTitle:title toView:[[[UIApplication sharedApplication] delegate] window] hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeWarning];
}

+ (void)showNetworkError {
    [self showErrorWithTitle:@"网络连接错误"];
}

+ (void)showVerifyCodeError {
    [self showErrorWithTitle:@"验证码错误"];
}

@end
