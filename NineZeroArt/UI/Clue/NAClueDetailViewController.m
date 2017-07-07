//
//  NAClueDetailViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/5.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NAClueDetailViewController.h"
#import "HTUIHeader.h"

#import "SKSwipeViewController.h"

@interface NAClueDetailViewController ()
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SKScanning *scanning;
@end

@implementation NAClueDetailViewController

- (instancetype)initWithScanning:(SKScanning*)scanning {
    self = [super init];
    if (self) {
        self.scanning = scanning;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    _nextButton = [UIButton new];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience_highlight"] forState:UIControlStateHighlighted];
    _nextButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_nextButton];
}

- (void)loadData {
    
}

- (void)nextButtonClick:(UIButton *)sender {
    SKSwipeViewController *controller =  [[SKSwipeViewController alloc] initWithScanning:self.scanning];
    [self.navigationController pushViewController:controller animated:NO];
}

@end
