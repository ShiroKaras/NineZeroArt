//
//  SKScanningRewardViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/13.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKScanningRewardView.h"
#import "HTUIHeader.h"
#import "OpenGLView.h"
#import "SKTicketView.h"

@interface SKScanningRewardView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HTLoginButton *sureButton;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) SKTicketView *card; // 奖品卡片
@property (nonatomic, strong) SKTicket *ticket;
@property (nonatomic, strong) SKScanning *scanningReward;
@end

@implementation SKScanningRewardView {
	float maxOffsetY;
}

- (instancetype)initWithFrame:(CGRect)frame reward:(SKScanning *)reward {
	self = [super initWithFrame:frame];
	if (self) {
		_scanningReward = reward;
		[self createUI];
	}
	return self;
}

- (void)createUI {
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
	_scrollView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.9];
	_scrollView.delaysContentTouches = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	[self addSubview:_scrollView];

	_sureButton = [HTLoginButton buttonWithType:UIButtonTypeCustom];
	_sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
	[_sureButton setTitle:@"完成" forState:UIControlStateNormal];
	_sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
	_sureButton.enabled = YES;
	[_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_sureButton];

	[HTProgressHUD show];
    
//	[[[SKServiceManager sharedInstance] answerService] getRewardWithQuestionID:nil
//									  rewardID:nil
//									  callback:^(BOOL success, SKResponsePackage *response) {
//									      [HTProgressHUD dismiss];
//									      if (success && response.result == 0) {
//										      _topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scan_gift"]];
//										      [_topImage sizeToFit];
//										      [self addSubview:_topImage];
//
//										      _topImage.top = ROUND_HEIGHT_FLOAT(68);
//										      _topImage.centerX = self.centerX;
//
//										      _ticket = [SKTicket mj_objectWithKeyValues:response.data[@"ticket"]];
//										      [self createTicketView];
//										      if (_ticket) {
//											      _card.top = _topImage.bottom + 25;
//											      _card.centerX = SCREEN_WIDTH / 2;
//											      maxOffsetY = _card.bottom;
//										      }
//										      _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 50, maxOffsetY + 100));
//									      } else if (success && response.result == 501) {
//										      _topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sacnning_reward2"]];
//										      [_topImage sizeToFit];
//										      [self addSubview:_topImage];
//
//										      _topImage.top = ROUND_HEIGHT_FLOAT(68);
//										      _topImage.centerX = self.centerX;
//
//										      _ticket = [SKTicket mj_objectWithKeyValues:response.data[@"ticket"]];
//										      [self createTicketView];
//										      if (_ticket) {
//											      _card.top = _topImage.bottom + 25;
//											      _card.centerX = SCREEN_WIDTH / 2;
//											      maxOffsetY = _card.bottom;
//										      }
//										      _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 50, maxOffsetY + 100));
//									      } else if (success && response.result == 502) {
//									      } else if (success && response.result == 503) {
//										      _topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sacnning_end"]];
//										      [_topImage sizeToFit];
//										      [self addSubview:_topImage];
//
//										      _topImage.centerY = self.centerY - 25;
//										      _topImage.centerX = self.centerX;
//									      } else {
//									      }
//									  }];

	if (NO_NETWORK) {
        _blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [self addSubview:self.blankView];
        _blankView.center = self.center;
	}
}

- (void)createTicketView {
	_card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 280, 108) reward:_ticket];
	[_scrollView addSubview:_card];
}

- (void)onClickSureButton {
	[self removeFromSuperview];
}

- (void)showTipsWithText:(NSString *)text {
	if (text.length == 0)
		text = @"操作失败";
	UIView *tipsBackView = [[UIView alloc] init];
	tipsBackView.backgroundColor = COMMON_PINK_COLOR;
	[KEY_WINDOW addSubview:tipsBackView];

	UILabel *tipsLabel = [[UILabel alloc] init];
	tipsLabel.font = [UIFont systemFontOfSize:16];
	tipsLabel.textAlignment = NSTextAlignmentCenter;
	tipsLabel.textColor = [UIColor whiteColor];
	[tipsBackView addSubview:tipsLabel];

	[tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.top.equalTo(KEY_WINDOW).offset(0);
	    make.width.equalTo(KEY_WINDOW);
	    make.height.equalTo(@30);
	}];

	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.edges.equalTo(tipsBackView);
	}];

	tipsLabel.text = text;
	CGFloat tipsBottom = tipsBackView.bottom;
	tipsBackView.bottom = 0;
	[UIView animateWithDuration:0.3
		animations:^{
		    tipsBackView.hidden = NO;
		    tipsBackView.bottom = tipsBottom;
		}
		completion:^(BOOL finished) {
		    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3
				animations:^{
				    tipsBackView.bottom = 0;
				}
				completion:^(BOOL finished) {
				    tipsBackView.bottom = tipsBottom;
				    tipsBackView.hidden = YES;
				}];
		    });
		}];
}
@end
