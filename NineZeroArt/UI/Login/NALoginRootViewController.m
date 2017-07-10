//
//  NALoginRootViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/4.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NALoginRootViewController.h"
#import "HTUIHeader.h"

#import "NAClueListViewController.h"
#import "NALoginViewController.h"

@interface NALoginRootViewController ()

@end

@implementation NALoginRootViewController

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
    WS(weakSelf);
    
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"img_logins_logo"];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((SCREEN_HEIGHT - 49 - 54) / 930 * 640);
        make.height.mas_equalTo(SCREEN_HEIGHT - 49 - 54);
        make.top.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"登录即代表你同意《隐私条款》";
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    [bottomLabel sizeToFit];
    [self.view addSubview:bottomLabel];
    bottomLabel.bottom = self.view.bottom - ROUND_HEIGHT_FLOAT(10);
    bottomLabel.centerX = self.view.centerX;
    
    NSArray *loginArray = @[@"wechat", @"qq", @"weibo", @"phone"];
    float padding = (self.view.width-ROUND_WIDTH_FLOAT(30)*2-ROUND_WIDTH_FLOAT(38)*4)/3;
    for (int i=0; i<4; i++) {
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(30)+i*(ROUND_WIDTH_FLOAT(38)+padding), bottomLabel.top-ROUND_HEIGHT_FLOAT(20)-ROUND_WIDTH_FLOAT(60), ROUND_WIDTH_FLOAT(38), ROUND_WIDTH_FLOAT(60))];
        [loginButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_logins_%@", loginArray[i]]] forState:UIControlStateNormal];
        [loginButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_logins_%@_highlight", loginArray[i]]] forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        loginButton.tag = 100+i;
    }
    
    UIImageView *loginTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_text"]];
    [self.view addSubview:loginTextImageView];
    loginTextImageView.centerX = self.view.centerX;
    loginTextImageView.bottom = bottomLabel.top - ROUND_HEIGHT_FLOAT(110);
}

- (void)didClickLoginButton:(UIButton*)sender {
    switch (sender.tag) {
        case 100: {
            NAClueListViewController *controller =  [[NAClueListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            break;
        }
        case 101: {
            NAClueListViewController *controller =  [[NAClueListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            break;
        }
        case 102: {
            NAClueListViewController *controller =  [[NAClueListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            break;
        }
        case 103: {
            NALoginViewController *controller =  [[NALoginViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
            break;
        }
        default:
            break;
    }
}

@end
