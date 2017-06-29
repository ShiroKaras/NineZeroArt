//
//  HTCommonViewController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/24.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTCommonViewController.h"
#import "HTUIHeader.h"

@interface HTCommonViewController ()

@property (nonatomic, strong) UILabel *tipsLabel;                ///< 提示
@property (nonatomic, strong) UIView *tipsBackView;              ///< 提示背景


@end

@implementation HTCommonViewController {
    NSInteger _secondsToCountDown;
    CGFloat _offset;
}

- (instancetype)init {
    if (self = [super init]) {
        _offset = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // tag值在xib里面设置
    _firstTextField = (UITextField *)[self.view viewWithTag:100];
    _secondTextField = (UITextField *)[self.view viewWithTag:200];
    _nextButton = (HTLoginButton *)[self.view viewWithTag:300];
    _verifyButton = (HTLoginButton *)[self.view viewWithTag:400];
    
    [_verifyButton addTarget:self action:@selector(didClickVerifyButton) forControlEvents:UIControlEventTouchUpInside];
    
    _firstTextField.delegate = self;
    _secondTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    _nextButton.enabled = NO;
    _verifyButton.enabled = NO;
    if ([self needScheduleVerifyTimer]) {
        [self needGetVerificationCode];
        _secondsToCountDown = 180;
        [self scheduleTimerCountDown];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tapGesture];
    
    // 5. 提示
    _tipsBackView = [[UIView alloc] init];
    _tipsBackView.backgroundColor = COMMON_PINK_COLOR;
    _tipsBackView.hidden = YES;
    [self.view addSubview:_tipsBackView];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.font = [UIFont systemFontOfSize:16];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor whiteColor];
    [_tipsBackView addSubview:_tipsLabel];
    
    // 5. 提示
    [_tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.width.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tipsBackView);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)setTipsOffsetY:(CGFloat)offset {
    _offset = offset;
    [_tipsBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(offset);
        make.width.equalTo(self.view);
        make.height.equalTo(@30);
    }];
}

- (void)showTipsWithText:(NSString *)text {
    _tipsLabel.text = text;
    CGFloat tipsBottom = _tipsBackView.bottom;
    _tipsBackView.bottom = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _tipsBackView.hidden = NO;
        _tipsBackView.bottom = tipsBottom;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _tipsBackView.bottom = 0;
            } completion:^(BOOL finished) {
                _tipsBackView.bottom = tipsBottom;
                _tipsBackView.hidden = YES;
            }];
        });
    }];

}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    ;
}

- (BOOL)needScheduleVerifyTimer {
    return NO;
}

- (void)needGetVerificationCode {
    ;
}

#pragma mark - Action

- (void)didClickVerifyButton {
    [self needGetVerificationCode];
    _secondsToCountDown = 180;
    _verifyButton.enabled = NO;
    [self scheduleTimerCountDown];
}

- (void)viewDidTap {
    [self.view endEditing:YES];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _firstTextField) {
        [_secondTextField becomeFirstResponder];
        return YES;
    }
    if (textField == _secondTextField) {
        if ([self isNextButtonValid]) {
            [self nextButtonNeedToBeClicked];
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if ([self isNextButtonValid]) {
        _nextButton.enabled = YES;
    } else {
        _nextButton.enabled = NO;
    }
}

#pragma mark - Public Method

- (BOOL)isNextButtonValid {
    if (_firstTextField.text.length != 0 &&
        _secondTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

- (void)scheduleTimerCountDown {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
    [self performSelector:@selector(scheduleTimerCountDown) withObject:nil afterDelay:1.0];
    _secondsToCountDown--;
    if (_secondsToCountDown == 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
        [_verifyButton setTitle:@"再发一次" forState:UIControlStateNormal];
        [_verifyButton setTitle:@"再发一次" forState:UIControlStateDisabled];
        _verifyButton.enabled = YES;
    } else {
        _verifyButton.enabled = NO;
        [UIView setAnimationsEnabled:NO];
        [_verifyButton setTitle:[NSString stringWithFormat:@"再发一次(%ld)", (long)_secondsToCountDown] forState:UIControlStateNormal];
        [_verifyButton setTitle:[NSString stringWithFormat:@"再发一次(%ld)", (long)_secondsToCountDown] forState:UIControlStateDisabled];
        [_verifyButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

@end
