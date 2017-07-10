//
//  NAProfileViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NAProfileViewController.h"
#import "HTUIHeader.h"
#import "FileService.h"

#import "SKProfileMyTicketsViewController.h"
#import "NAAboutViewController.h"

@interface NAProfileViewController ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *cacheLabel;
@end

@implementation NAProfileViewController {
    float         cacheSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakSelf);
    
    //标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 49)];
    [self.view addSubview:titleView];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_titletext"]];
    [titleView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    
    _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(64)/2;
    _avatarImageView.layer.masksToBounds = YES;
    [self.view addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64)));
        make.centerX.equalTo(titleView);
        make.top.equalTo(titleView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(20));
    }];
    
    _usernameLabel = [UILabel new];
    _usernameLabel.text = @"我是一个零仔";
    _usernameLabel.textColor = [UIColor whiteColor];
    _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    [self.view addSubview:_usernameLabel];
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(10));
    }];
    
    [self.view layoutIfNeeded];
    NSArray *titleArray = @[@"我的礼券",@"清除缓存",@"关于"];
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _usernameLabel.bottom+ROUND_HEIGHT_FLOAT(30+50*i), weakSelf.view.width, ROUND_HEIGHT_FLOAT(50))];
        view.tag = 100+i;
        [self.view addSubview:view];
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(16, ROUND_HEIGHT_FLOAT(49), view.width-32, 1)];
        underline.backgroundColor = COMMON_SELECTED_COLOR;
        [view addSubview:underline];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = COMMON_TEXT_2_COLOR;
        titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        [titleLabel sizeToFit];
        [view addSubview:titleLabel];
        titleLabel.left = 16;
        titleLabel.centerY = view.height/2;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
        [view addGestureRecognizer:tapGesture];
        
        if (i==0|i==2) {
            UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userpage_next"]];
            [view addSubview:arrow];
            arrow.right = view.right-11.5;
            arrow.centerY = view.height/2;
        } else if (i==1) {
            _cacheLabel = [UILabel new];
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            [self listFileAtPath:cacheFilePath];
            _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
            _cacheLabel.textColor = [UIColor whiteColor];
            _cacheLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
            [view addSubview:_cacheLabel];
            [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).offset(-20);
                make.centerY.equalTo(view);
            }];
            
            UIButton *clearCacheButton = [UIButton new];
            [clearCacheButton addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:clearCacheButton];
            [clearCacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(view);
                make.center.equalTo(view);
            }];
        }
    }
    
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _usernameLabel.bottom+ROUND_HEIGHT_FLOAT(30+50*3+50), self.view.width, ROUND_HEIGHT_FLOAT(50))];
    [quitButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [quitButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [quitButton setImage:[UIImage imageNamed:@"img_userpage_exit"] forState:UIControlStateNormal];
    [quitButton setImage:[UIImage imageNamed:@"img_userpage_exit_highlight"] forState:UIControlStateHighlighted];
    [quitButton addTarget:self action:@selector(didClickQuitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserBaseInfoCallback:^(BOOL success, SKUserInfo *response) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:response.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _usernameLabel.text = response.user_name;
    }];
}

- (void)listFileAtPath:(NSString *)path {
    cacheSize = 0;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        cacheSize += [FileService fileSizeAtPath:fullPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) {
            [self listFileAtPath:fullPath];
        }
    }
}

#pragma mark - Actions

- (void)showPromptWithText:(NSString*)text {
    [[self.view viewWithTag:9002] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 9002;
    promptView.size = promptImageView.size;
    promptView.center = self.view.center;
    promptView.alpha = 0;
    [self.view addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.frame = CGRectMake(8.5, 11, promptView.width-17, 57);
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

- (void)clearCache {
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [FileService clearCache:cacheFilePath];
    [self listFileAtPath:cacheFilePath];
    _cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", cacheSize];
    
    [self showPromptWithText:@"已清理"];
}

- (void)didClickQuitButton:(UIButton*)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        [[[SKServiceManager sharedInstance] loginService] quitLogin];
        NALoginRootViewController *rootController = [[NALoginRootViewController alloc] init];
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = navController;
    }
}

- (void)viewDidTap:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *v = (UIView *)[gestureRecognizer view];
    switch (v.tag) {
        case 100:{
            SKProfileMyTicketsViewController *controller = [[SKProfileMyTicketsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 102: {
            NAAboutViewController *controller = [[NAAboutViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
