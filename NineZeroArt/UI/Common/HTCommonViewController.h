//
//  HTCommonViewController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/24.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTLoginButton.h"

@interface HTCommonViewController : UIViewController <UITextFieldDelegate> {
@protected
    UITextField *_firstTextField;
    UITextField *_secondTextField;
    HTLoginButton *_nextButton;
    HTLoginButton *_verifyButton;
}

- (BOOL)isNextButtonValid;
- (void)didClickVerifyButton;
- (void)showTipsWithText:(NSString *)text;
- (void)setTipsOffsetY:(CGFloat)offset;

@end

@interface HTCommonViewController (SubClass)

// 验证码倒计时
- (BOOL)needScheduleVerifyTimer;
// 下一步操作应该进行
- (void)nextButtonNeedToBeClicked;
// 申请验证码
- (void)needGetVerificationCode;

@end
