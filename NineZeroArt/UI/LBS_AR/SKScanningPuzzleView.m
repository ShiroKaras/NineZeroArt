//
//  SKScanningPuzzleView.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKScanningPuzzleView.h"
#import "HTUIHeader.h"

@interface SKScanningPuzzleView ()

@property (nonatomic, strong) NSString *backgroundImageURL;
@property (nonatomic, strong) NSArray *linkClarity;
@property (nonatomic, strong) NSArray *rewardAction;
@property (nonatomic, strong) NSString *defaultPic;

@property (nonatomic, strong) UIImageView *scanningBoarderImageView;
@property (nonatomic, strong) UIImageView *scanningAnimationView;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) UIButton *puzzleButton;
@property (nonatomic, strong) UIView *puzzleView;

@property (nonatomic, strong) NSMutableSet *puzzleLayers;

@property (nonatomic, strong) UIButton *boxButton;
@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation SKScanningPuzzleView {
	BOOL _isShowPuzzles;	  // 是否显示已收集到的碎片，default is NO
	BOOL _isExchangeButtonEnable; // 兑换按钮是否可用， default is NO
}

- (instancetype)initWithLinkClarity:(NSArray *)clarity rewardAction:(NSArray *)rewardAction defaultPic:(NSString *)defaultPic {
	if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
		_isShowPuzzles = NO;
		_isExchangeButtonEnable = NO;

		self.linkClarity = clarity;
		self.rewardAction = rewardAction;
		self.defaultPic = defaultPic;

		[self showAnimationView];
		[self showPuzzleButton];
	}

	return self;
}

- (void)showAnimationView {
	if (!_scanningBoarderImageView) {
		_scanningBoarderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_frame"]];
		[self addSubview:_scanningBoarderImageView];

		[_scanningBoarderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.mas_equalTo(243.f);
		    make.height.mas_equalTo(243.f);
		    make.center.equalTo(self);
		}];

		NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:23];
		for (int i = 0; i != 23; i++) {
			UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"gif_scanning_puzzlescanning_00%02d", i]];
			[images addObject:animatedImage];
		}
		_scanningAnimationView = [[UIImageView alloc] init];
		_scanningAnimationView.animationImages = images;
		_scanningAnimationView.animationDuration = 1.0 * 23.f / 15.f;
		[self addSubview:_scanningAnimationView];

		[_scanningAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.mas_equalTo(_scanningBoarderImageView.width - 8);
		    make.height.mas_equalTo(_scanningBoarderImageView.height - 8);
		    make.center.equalTo(_scanningBoarderImageView);
		}];
	}

	_scanningAnimationView.hidden = NO;
	_scanningBoarderImageView.hidden = NO;
	[_scanningAnimationView startAnimating];
}

- (void)hideAnimationView {
	[_scanningAnimationView stopAnimating];
	_scanningAnimationView.hidden = YES;
	_scanningBoarderImageView.hidden = YES;
}

- (void)showPuzzleButton {
	if (!_puzzleButton) {
		self.puzzleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		[_puzzleButton addTarget:self action:@selector(tapPuzzleButton) forControlEvents:UIControlEventTouchDown];
		[_puzzleButton setImage:[UIImage imageNamed:@"btn_scanning_puzzle"] forState:UIControlStateNormal];
		[_puzzleButton setImage:[UIImage imageNamed:@"btn_scanning_puzzle_highlight"] forState:UIControlStateHighlighted];
		[self addSubview:_puzzleButton];

		[_puzzleButton mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.centerX.equalTo(self);
		    make.bottom.equalTo(self).offset(-55.f);
		}];
	}
	_puzzleButton.hidden = NO;
}

- (void)hidePuzzleButton {
	_puzzleButton.hidden = YES;
}

- (void)setupExchangeButton {
	if (!_exchangeButton) {
		_exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 125, 40)];
		[_exchangeButton setImage:[UIImage imageNamed:@"btn_scanning_exchange_activated"] forState:UIControlStateNormal];
		[_exchangeButton setImage:[UIImage imageNamed:@"btn_scanning_exchange_default"] forState:UIControlStateDisabled];
		[_exchangeButton setImage:[UIImage imageNamed:@"btn_scanning_exchange_highlight"] forState:UIControlStateHighlighted];
		[_exchangeButton addTarget:self action:@selector(exchangeGifts) forControlEvents:UIControlEventTouchDown];
		[self addSubview:_exchangeButton];

		__weak __typeof__(self) weakSelf = self;
		[_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.centerX.equalTo(weakSelf);
		    make.top.mas_equalTo(_puzzleView.bottom + 28.f);
		}];
	}

	[self updatePuzzleView];

	_exchangeButton.hidden = NO;
	_exchangeButton.enabled = _isExchangeButtonEnable;
}

- (void)hideExchangeButton {
	_exchangeButton.hidden = YES;
}

- (void)showPuzzleView {
	if (!_puzzleView) {
		_puzzleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 257.f, 257.f)];
		[self addSubview:_puzzleView];
		_puzzleView.centerX = self.centerX;
		_puzzleView.centerY = self.centerY;

		CGRect imageFrame = CGRectMake(0, 0, _puzzleView.width, _puzzleView.height);

		UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:imageFrame];

		[backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_defaultPic]];
		[_puzzleView addSubview:backgroundImageView];
	}

	_puzzleView.hidden = NO;
	[self setupExchangeButton];
}

- (void)setupPuzzleView {
	if (_isShowPuzzles) {
		[UIView animateWithDuration:0.2f
				 animations:^{
				     [self hideAnimationView];
				     _puzzleButton.transform = CGAffineTransformRotate(_puzzleButton.transform, M_PI_4);
				 }];

		[self showPuzzleView];
	} else {
		[UIView animateWithDuration:0.2f
				 animations:^{
				     [self showAnimationView];
				     _puzzleButton.transform = CGAffineTransformRotate(_puzzleButton.transform, -M_PI_4);
				 }];
		[self hidePuzzleView];
	}
}

- (void)updatePuzzleView {
	BOOL canExchange = YES;

	if (!_puzzleLayers) {
		_puzzleLayers = [[NSMutableSet alloc] initWithCapacity:_linkClarity.count];
	}

	for (NSUInteger i = 0; i < _rewardAction.count; i++) {
		if ([[_rewardAction objectAtIndex:i] isEqualToString:@"1"]) {
			CALayer *imageLayer = [[CALayer alloc] init];
			imageLayer.frame = _puzzleView.layer.bounds;
			[[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[_linkClarity objectAtIndex:i]]
				options:SDWebImageRetryFailed
				progress:^(NSInteger receivedSize, NSInteger expectedSize) {

				}
				completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
				    imageLayer.contents = (__bridge id _Nullable)(image.CGImage);
				}];
			[_puzzleView.layer addSublayer:imageLayer];
			[_puzzleLayers addObject:imageLayer];
		} else {
			canExchange = NO;
		}
	}
	_isExchangeButtonEnable = canExchange;
}

- (void)hidePuzzleView {
	for (CALayer *subLayer in _puzzleLayers) {
		[subLayer removeFromSuperlayer];
	}
	[_puzzleLayers removeAllObjects];

	_puzzleView.hidden = YES;
	[self hideExchangeButton];
}

- (void)showBoxView {
	if (!_boxButton) {
		self.maskLayer = [[CALayer alloc] init];
		self.maskLayer.backgroundColor = [UIColor colorWithHex:0x000000].CGColor;
		self.maskLayer.frame = self.frame;
		[self.layer addSublayer:_maskLayer];

		_boxButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[_boxButton addTarget:self action:@selector(onTapBoxButton) forControlEvents:UIControlEventTouchDown];
		[_boxButton setImage:[UIImage imageNamed:@"btn_scanning_gift"] forState:UIControlStateNormal];
		[self addSubview:_boxButton];

		__weak __typeof__(self) weakSelf = self;
		[_boxButton mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.center.equalTo(weakSelf);
		    make.width.mas_equalTo(150);
		    make.height.mas_equalTo(114);
		}];
	}
	_boxButton.hidden = NO;
	_maskLayer.hidden = NO;
	_puzzleButton.userInteractionEnabled = NO;

	_boxButton.transform = CGAffineTransformMakeScale(0, 0);
	self.maskLayer.opacity = 0.0;

	[UIView animateWithDuration:0.3f
			      delay:0.0f
			    options:UIViewAnimationOptionCurveEaseInOut
			 animations:^{
			     _boxButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
			     _maskLayer.opacity = 0.8;
			 }
			 completion:nil];
}

- (void)hideBoxView {
	_boxButton.hidden = YES;
	_maskLayer.hidden = YES;
	_puzzleButton.userInteractionEnabled = YES;
}

#pragma Action
- (void)tapPuzzleButton {
	_isShowPuzzles = !_isShowPuzzles;

	if ([_delegate respondsToSelector:@selector(scanningPuzzleView:isShowPuzzles:)]) {
		[_delegate scanningPuzzleView:self isShowPuzzles:_isShowPuzzles];
	}
}

- (void)exchangeGifts {
	[self hidePuzzleView];
	[self hidePuzzleButton];
	[self hideExchangeButton];

	if ([_delegate respondsToSelector:@selector(scanningPuzzleView:didTapExchangeButton:)]) {
		[_delegate scanningPuzzleView:self didTapExchangeButton:_exchangeButton];
	}
}

- (void)onTapBoxButton {
	if ([_delegate respondsToSelector:@selector(scanningPuzzleView:didTapBoxButton:)]) {
		[_delegate scanningPuzzleView:self didTapBoxButton:_boxButton];
	}
}

@end
