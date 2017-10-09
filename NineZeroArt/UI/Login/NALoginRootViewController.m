//
//  NALoginRootViewController.m
//  NineZeroCamera
//
//  Created by SinLemon on 2017/7/4.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NALoginRootViewController.h"
#import "HTUIHeader.h"

#import "NCMainCameraViewController.h"
#import "SKUserAgreementViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "FWApplyFilter.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface NALoginRootViewController ()
@property (strong, nonatomic) UIView *backView;
@end

@implementation NALoginRootViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.backView.transform = CGAffineTransformIdentity;
    self.backView.transform = CGAffineTransformMakeRotation(M_PI*.5);//翻转角度
    self.backView.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height+100, [[UIScreen mainScreen] bounds].size.width);
    self.backView.top = 0;
    self.backView.left = 0;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //无权限
        return ;
    }
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageDataToSavedPhotosAlbum:nil metadata:(__bridge id)nil completionBlock:^(NSURL *assetURL, NSError *error) {
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {    
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [self.view addSubview:_backView];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_login_background_%lf", SCREEN_WIDTH]];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backView addSubview:backImageView];
    backImageView.size = CGSizeMake(SCREEN_HEIGHT, SCREEN_WIDTH);
    backImageView.top = 0;
    backImageView.left = 0;
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-50, SCREEN_HEIGHT, 50)];
    [loginButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_login_wechat_%lf", SCREEN_WIDTH]] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_login_wechat_%lf_highlight", SCREEN_WIDTH]] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(didClickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 100;
    [self.backView addSubview:loginButton];
    
    [[[SKServiceManager sharedInstance] commonService] isOnlineCallback:^(BOOL success, SKResponsePackage *response) {
        long isOnline = [response.data[@"is_onlein"] longValue];
        if (!isOnline) {
            UIButton *guestLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-100-15, SCREEN_HEIGHT, 50)];
            [guestLogin setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_login_tourist_%lf", SCREEN_WIDTH]] forState:UIControlStateNormal];
            [guestLogin setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_login_tourist_%lf_highlight", SCREEN_WIDTH]] forState:UIControlStateHighlighted];
            [guestLogin addTarget:self action:@selector(didClickLoginButton2:) forControlEvents:UIControlEventTouchUpInside];
            [self.backView addSubview:guestLogin];
        }
    }];
}

- (void)didClickLoginButton2:(UIButton*)sender {
    NCMainCameraViewController *controller = [[NCMainCameraViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didClickAgreementButton:(UIButton *)sender {
    SKUserAgreementViewController *controller = [[SKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickLoginButton:(UIButton*)sender {
    switch (sender.tag) {
        case 100: {
            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                       if (state == SSDKResponseStateSuccess) {
                           DLog(@"uid=%@", user.uid);
                           DLog(@"%@", user.credential);
                           DLog(@"token=%@", user.credential.token);
                           DLog(@"nickname=%@", user.nickname);
                           
                           [self loginWithUser:user];
                       }
                       
                       else {
                           DLog(@"%@", error);
                       }
                       
                   }];
            break;
        }
        default:
            break;
    }
}

- (void)loginWithUser:(SSDKUser *)user {
    SKLoginUser *loginUser = [SKLoginUser new];
    loginUser.open_id = user.uid;
    
    [[[SKServiceManager sharedInstance] loginService] loginWithThirdPlatform:loginUser
                                                                    callback:^(BOOL success, SKResponsePackage *response) {
                                                                        DLog(@"%@", response);
                                                                        if (success) {
                                                                            if (response.code == 0) {
                                                                                NCMainCameraViewController *controller =  [[NCMainCameraViewController alloc] init];
                                                                                AppDelegateInstance.mainController = controller;
                                                                                HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
                                                                                AppDelegateInstance.window.rootViewController = navController;
                                                                                [AppDelegateInstance.window makeKeyAndVisible];
                                                                            } else {
                                                                                DLog(@"%ld", (long)response.code);
                                                                            }
                                                                        } else {
                                                                            [self showTipsWithText:@"网络连接错误"];
                                                                        }
                                                                    }];
}

@end
