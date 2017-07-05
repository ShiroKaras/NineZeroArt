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
@end

@implementation NAClueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
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
    [_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x0e0e0e alpha:0.3]] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience_highlight"] forState:UIControlStateHighlighted];
    _nextButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_nextButton];
}

- (void)nextButtonClick:(UIButton *)sender {
    SKSwipeViewController *controller =  [[SKSwipeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

@end
