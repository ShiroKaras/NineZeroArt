//
//  SKPopupGetPuzzleView.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKPopupGetPuzzleView.h"
#import "HTUIHeader.h"

@implementation SKPopupGetPuzzleView

- (instancetype)initWithPuzzleImageURL:(NSString *)imageURL {
	if (self = [self initWithFrame:SCREEN_BOUNDS]) {
		UIView *alphaView = [[UIView alloc] initWithFrame:self.bounds];
		alphaView.backgroundColor = [UIColor blackColor];
		alphaView.alpha = 0;
		[self addSubview:alphaView];

		[UIView animateWithDuration:0.3
				 animations:^{
				     alphaView.alpha = 0.5;
				 }];

		UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
			bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_640"];
		} else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
			bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_750"];
		} else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
			bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_1242"];
		}

		[self addSubview:bgImageView];

		__weak __typeof__(self) weakSelf = self;
		UIImageView *puzzleImageView = [[UIImageView alloc] init];
		[puzzleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
					  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
					      [puzzleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
						  make.size.mas_equalTo(image.size);
					      }];
					      [puzzleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
						  make.centerY.equalTo(weakSelf.mas_top).offset(252);
						  make.centerX.equalTo(weakSelf);
					      }];
					  }];
		[self addSubview:puzzleImageView];

		[puzzleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.centerY.equalTo(weakSelf.mas_top).offset(252);
		    make.centerX.equalTo(weakSelf);
		}];

		UIImageView *giftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_puzzlegift"]];
		[self addSubview:giftImage];

		[giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.top.equalTo(puzzleImageView.mas_bottom).offset(75);
		    make.centerX.equalTo(weakSelf);
		}];

		UILabel *bottomLabel = [UILabel new];
		bottomLabel.text = @"点击任意区域关闭";
		bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
		bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
		[bottomLabel sizeToFit];
		[self addSubview:bottomLabel];
		[bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.centerX.equalTo(weakSelf);
		    make.bottom.equalTo(weakSelf).offset(-16);
		}];

		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
		[self addGestureRecognizer:tap];
	}
	return self;
}

- (void)close {
	[self removeFromSuperview];
	if ([_delegate respondsToSelector:@selector(didRemoveFromSuperView)]) {
		[_delegate didRemoveFromSuperView];
	}
}

@end
