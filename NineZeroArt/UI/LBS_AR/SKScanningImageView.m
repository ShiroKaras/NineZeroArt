//
//  SKScanningImageView.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/23.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKScanningImageView.h"
#import "HTUIHeader.h"

@interface SKScanningImageView ()

@property (nonatomic, strong) NSTimer *timerScanningGridLine;

@end

@implementation SKScanningImageView

- (void)showScanningGridLine {
	if (!_scanningGridLine) {
		//扫描线
		_scanningGridLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_gridlines"]];
		[_scanningGridLine sizeToFit];
		_scanningGridLine.top = 0;
		_scanningGridLine.right = 0;
		[self addSubview:_scanningGridLine];

		_timerScanningGridLine = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loopScanningGridLine) userInfo:nil repeats:YES];
	}
	_scanningGridLine.hidden = NO;
}

- (void)removeScanningGridLine {
	[_scanningGridLine removeFromSuperview];
	_scanningGridLine = nil;

	[_timerScanningGridLine invalidate];
	_timerScanningGridLine = nil;
}

- (void)setUpGiftView {
	if (!self.giftBackImageView) {
		self.giftBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loadingvideo_gift_2"]];
		self.giftBackImageView.size = CGSizeMake(54, 42);
		self.giftBackImageView.bottom = self.bottom - 14 - 49;
		self.giftBackImageView.left = self.right;
		[self addSubview:self.giftBackImageView];

		self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.giftButton addTarget:self action:@selector(getGift) forControlEvents:UIControlEventTouchUpInside];
		[self.giftButton setBackgroundImage:[UIImage imageNamed:@"img_loadingvideo_gift_3"] forState:UIControlStateNormal];
		self.giftButton.size = self.giftBackImageView.size;
		self.giftButton.bottom = self.giftBackImageView.bottom;
		self.giftButton.right = self.giftBackImageView.right;

		[self addSubview:self.giftButton];
		//摇动动画
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.fromValue = @(-0.2);
		animation.toValue = @(0.2);
		animation.duration = 0.2;
		animation.repeatCount = 100;
		animation.autoreverses = YES;
		[self.giftButton.layer addAnimation:animation forKey:@"animateLayer"];

		self.giftMascotHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loadingvideo_gift_1"]];
		[self.giftMascotHand sizeToFit];
		self.giftMascotHand.left = self.right;
		self.giftMascotHand.centerY = self.giftButton.centerY;
		[self addSubview:self.giftMascotHand];
	}
}

- (void)pushGift {
	[UIView animateWithDuration:0.5
		animations:^{
		    self.giftBackImageView.right = self.right - 14;
		    self.giftButton.right = self.giftBackImageView.right;
		    self.giftMascotHand.right = self.right;
		}
		completion:^(BOOL finished) {
		    [UIView animateWithDuration:0.5
				     animations:^{
					 self.giftMascotHand.left = self.right;
				     }];
		}];
}

- (void)removeGiftView {
	[_giftButton removeFromSuperview];
	_giftButton = nil;
	[_giftMascotHand removeFromSuperview];
	_giftMascotHand = nil;
	[_giftBackImageView removeFromSuperview];
	_giftBackImageView = nil;
}

#pragma action

- (void)getGift {
	if ([_delegate respondsToSelector:@selector(scanningImageView:didTapGiftButton:)]) {
		[_delegate scanningImageView:self didTapGiftButton:_giftButton];
	}
}

- (void)loopScanningGridLine {
	[UIView animateWithDuration:1.0
		animations:^{
		    _scanningGridLine.left = SCREEN_WIDTH;
		}
		completion:^(BOOL finished) {
		    _scanningGridLine.right = 0;
		}];
}

@end
