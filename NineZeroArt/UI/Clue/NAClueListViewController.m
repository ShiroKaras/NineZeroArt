//
//  NAClueListViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NAClueListViewController.h"
#import "HTUIHeader.h"

@interface NAClueListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray* clueArray;
@end

@implementation NAClueListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_cluepage_titletext"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    
}
#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NAClueCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NAClueCell class]) forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[NAClueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NAClueCell class])];
    }
    cell.titleLabel.text = @"北京美年达周年庆";
    cell.placeLabel.text = @"北京";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_WIDTH_FLOAT(128);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
//    return self.clueArray.count;
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
//        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_labpage_loading.imageset"]];
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
