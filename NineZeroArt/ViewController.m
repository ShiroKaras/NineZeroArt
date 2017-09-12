//
//  ViewController.m
//  NineZeroCamera
//
//  Created by SinLemon on 2017/6/29.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "ViewController.h"
#import "HTUIHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton  addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton sizeToFit];
    [self.view addSubview:loginButton];
    loginButton.centerX = self.view.centerX;
    loginButton.bottom = self.view.bottom - 100;
}

- (void)didClickLoginButton:(UIButton *)sender {

}
    
@end
