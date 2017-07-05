//
//  NALoginViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/4.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NALoginViewController.h"
#import "HTUIHeader.h"

#import "NACreateAccountViewController.h"
#import "NAClueListViewController.h"

@interface NALoginViewController ()
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *getVerifyCodeButton;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation NALoginViewController{
    NSInteger _secondsToCountDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 49)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_titletext"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, 60)];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.textColor = COMMON_TEXT_2_COLOR;
    [_phoneTextField setValue:COMMON_TEXT_2_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 60)];
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_phoneTextField];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(16, _phoneTextField.bottom, self.view.width-32, 1)];
    line1.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:line1];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.bottom+1, self.view.width, 60)];
    _passwordTextField.placeholder = @"请输入验证码";
    _passwordTextField.textColor = COMMON_TEXT_2_COLOR;
    [_passwordTextField setValue:COMMON_TEXT_2_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 60)];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_passwordTextField];
    
    _getVerifyCodeButton = [UIButton new];
    _getVerifyCodeButton.layer.cornerRadius = 5;
    _getVerifyCodeButton.layer.borderWidth = 1;
    _getVerifyCodeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _getVerifyCodeButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeButton addTarget:self action:@selector(didClickGetVerifyCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVerifyCodeButton];
    _getVerifyCodeButton.size = CGSizeMake(76, 30);
    _getVerifyCodeButton.centerY = _passwordTextField.centerY;
    _getVerifyCodeButton.right = self.view.right-16;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(16, _passwordTextField.bottom, self.view.width-32, 1)];
    line2.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:line2];
    
    _nextButton = [UIButton new];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
    _nextButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_nextButton];
}

- (void)nextButtonClick:(UIButton *)sender {
    NACreateAccountViewController *controller = [[NACreateAccountViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickGetVerifyCodeButton:(UIButton*)sender {
//    [[[SKServiceManager sharedInstance] loginService] sendVerifyCodeWithMobile:self.loginUser.user_mobile callback:^(BOOL success, SKResponsePackage *response) {
//        
//    }];
    
    _secondsToCountDown = 60;
    [self scheduleTimerCountDown];
}

- (void)scheduleTimerCountDown {
    [self performSelector:@selector(scheduleTimerCountDown) withObject:nil afterDelay:1.0];
    _secondsToCountDown--;
    if (_secondsToCountDown == 0) {
        _getVerifyCodeButton.alpha = 1.0;
        _getVerifyCodeButton.size = CGSizeMake(76, 30);
        _getVerifyCodeButton.right = self.view.right-16;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
        [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        _getVerifyCodeButton.enabled = YES;
    } else {
        _getVerifyCodeButton.alpha = 0.7;
        _getVerifyCodeButton.enabled = NO;
        [UIView setAnimationsEnabled:NO];
        _getVerifyCodeButton.size = CGSizeMake(86, 30);
        _getVerifyCodeButton.right = self.view.right-16;
        [_getVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新获取%lds", (long)_secondsToCountDown] forState:UIControlStateNormal];
        [_getVerifyCodeButton setTitle:[NSString stringWithFormat:@"重新获取%lds", (long)_secondsToCountDown] forState:UIControlStateDisabled];
        [_getVerifyCodeButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if (_phoneTextField.text.length > 11) {
        _phoneTextField.text = [_phoneTextField.text substringToIndex:11];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 50, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
}

@end
