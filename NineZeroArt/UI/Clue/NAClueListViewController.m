//
//  NAClueListViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NAClueListViewController.h"
#import "HTUIHeader.h"

#import "NAClueDetailViewController.h"
#import "NAProfileViewController.h"

@interface NAClueListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKScanning*>* clueArray;
@end

@implementation NAClueListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NAClueCell class] forCellReuseIdentifier:NSStringFromClass([NAClueCell class])];
    [self.view addSubview:self.tableView];
    
    UIView *tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    tableViewFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableViewFooterView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 49)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_logo"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    //个人主页
    UIButton *profileButton = [UIButton new];
    [profileButton setImage:[UIImage imageNamed:@"btn_homepage_personal"] forState:UIControlStateNormal];
    [profileButton setImage:[UIImage imageNamed:@"btn_homepage_personal_highlight"] forState:UIControlStateHighlighted];
    [profileButton addTarget:self action:@selector(didClickProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:profileButton];
    profileButton.size = CGSizeMake(32, 32);
    profileButton.centerY = headerView.centerY;
    profileButton.left = 16;
    
//    if (NO_NETWORK) {
//        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//        converView.backgroundColor = COMMON_BG_COLOR;
//        [self.view addSubview:converView];
//        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
//        [_blankView setOffset:10];
//        [converView addSubview:_blankView];
//        _blankView.center = converView.center;
//    } else {
//    }
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] scanningService] getScanningListWithCallBack:^(BOOL success, NSArray<SKScanning *> *scanningList) {
        self.clueArray = scanningList;
        [self.tableView reloadData];
    }];
}

#pragma mark - Actions

- (void)didClickProfileButton:(UIButton *)sender {
    NAProfileViewController *controller = [[NAProfileViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAClueCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NAClueCell class]) forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[NAClueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NAClueCell class])];
    }
    
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:self.clueArray[indexPath.row].list_pic]];
    cell.titleLabel.text = self.clueArray[indexPath.row].activity_name;
    cell.titleLabel_shadow.text = self.clueArray[indexPath.row].activity_name;
    cell.placeLabel.text = self.clueArray[indexPath.row].activity_place;
    cell.placeLabel_shadow.text = self.clueArray[indexPath.row].activity_place;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(128);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NAClueDetailViewController *controller =  [[NAClueDetailViewController alloc] initWithScanning:self.clueArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clueArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end


@interface NAClueCell()

@end

@implementation NAClueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _backImageView = [UIImageView new];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, ROUND_WIDTH_FLOAT(128)));
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
        }];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cluepage_place"]];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(23), ROUND_WIDTH_FLOAT(23)));
            make.top.equalTo(ROUND_WIDTH(68));
            make.left.equalTo(ROUND_WIDTH(6));
        }];
        
        _titleLabel_shadow = [UILabel new];
        _titleLabel_shadow.font = PINGFANG_ROUND_FONT_OF_SIZE(20);
        _titleLabel_shadow.textColor = COMMON_TITLE_BG_COLOR;
        [self.contentView addSubview:_titleLabel_shadow];
        [_titleLabel_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(7);
            make.right.equalTo(self.contentView.mas_right).offset(-6);
            make.centerY.equalTo(icon).offset(1);;
            make.height.equalTo(ROUND_WIDTH(26));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(20);
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(6);
            make.right.equalTo(self.contentView.mas_right).offset(-6);
            make.centerY.equalTo(icon);
            make.height.equalTo(ROUND_WIDTH(26));
        }];

        _placeLabel_shadow = [UILabel new];
        _placeLabel_shadow.font = PINGFANG_ROUND_FONT_OF_SIZE(16);
        _placeLabel_shadow.textColor = COMMON_TITLE_BG_COLOR;
        [self.contentView addSubview:_placeLabel_shadow];
        [_placeLabel_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel).offset(1);
            make.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(9);
            make.height.equalTo(ROUND_WIDTH(22));
        }];
        
        _placeLabel = [UILabel new];
        _placeLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(16);
        _placeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_placeLabel];
        [_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.height.equalTo(ROUND_WIDTH(22));
        }];
    }
    return self;
}


@end
