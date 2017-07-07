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
        }
    }
    
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _usernameLabel.bottom+ROUND_HEIGHT_FLOAT(30+50*3+50), self.view.width, ROUND_HEIGHT_FLOAT(50))];
    [quitButton setBackgroundColor:COMMON_TITLE_BG_COLOR];
    [quitButton setImage:[UIImage imageNamed:@"img_userpage_exit"] forState:UIControlStateNormal];
    [quitButton setImage:[UIImage imageNamed:@"img_userpage_exit_highlight"] forState:UIControlStateHighlighted];
    [quitButton addTarget:self action:@selector(didClickQuitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
}

- (void)loadData {
    SKLoginUser *user = [[SKStorageManager sharedInstance] getLoginUser];
    NSLog(@"%@",user.user_avatar);
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[SKStorageManager sharedInstance] getLoginUser].user_avatar]];
    _usernameLabel.text = [[SKStorageManager sharedInstance] getLoginUser].user_name;
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

- (void)didClickQuitButton:(UIButton*)sender {
    
}

- (void)viewDidTap:(UITapGestureRecognizer *)gestureRecognizer {
    UIView *v = (UIView *)[gestureRecognizer view];
    switch (v.tag) {
        case 100:{
            SKProfileMyTicketsViewController *controller = [[SKProfileMyTicketsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
