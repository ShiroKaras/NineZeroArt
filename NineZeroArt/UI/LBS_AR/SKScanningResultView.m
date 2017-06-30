//
//  SKScanningResultView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/10.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKScanningResultView.h"
#import "HTUIHeader.h"
#import "OpenGLView.h"
#import "SKARRewardController.h"
#import "SKScanningRewardView.h"

@interface SKScanningResultView ()

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UIImageView *scanningImageView;
@property (nonatomic, strong) HTImageView *captureSuccessImageView;
@property (nonatomic, strong) UIView *successBackgroundView;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) int swipeType; //0 扫一扫, 1 LBS

@property (nonatomic, strong) SKScanning *scanning;
@end

@implementation SKScanningResultView

- (instancetype)initWithFrame:(CGRect)frame withIndex:(NSUInteger)index swipeType:(int)type {
	if (self = [super initWithFrame:frame]) {
		_swipeType = type;
		_index = index;
		[self loadData];
	}
	return self;
}

- (void)loadData {
	//    switch (_swipeType) {
	//        case 0:{
	//            [[[HTServiceManager sharedInstance] questionService] getScanning:^(BOOL success, NSArray<HTScanning *> *scanningList) {
	//                _scanning = scanningList[_index];
	//                DLog(@"Scanning Type:%@", _scanning.link_type);
	//                if ([_scanning.link_type isEqualToString:@"0"] ) {
	//                    [self createVideoWithUrlString:_scanning.link_url];
	//                } else ianswerScanningARf ([_scanning.link_type isEqualToString:@"1"] || [_scanning.link_type isEqualToString:@"2"]) {
	//                    [self createImageWithUrlString:_scanning.link_url];
	//                }
	//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	//                button.frame = CGRectMake(0, 0, self.width, self.height);
	//                button.tag = _swipeType;
	//                [button addTarget:self  action:@selector(showScanningResult:) forControlEvents:UIControlEventTouchUpInside];
	//                [self addSubview:button];
	//            }];
	//            break;
	//        }
	//        case 1:{
	//            [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
	//                [self createImageWithUrlString:[questionList lastObject].question_ar_pet];
	//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	//                button.frame = CGRectMake(0, 0, self.width, self.height);
	//                button.tag = _swipeType;
	//                [button addTarget:self  action:@selector(showScanningResult:) forControlEvents:UIControlEventTouchUpInside];
	//                [self addSubview:button];
	//            }];
	//            break;
	//        }
	//        default:
	//            break;
	//    }
}

- (void)createVideoWithUrlString:(NSString *)urlString {
	//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"trailer_video" ofType:@"mp4"];
	NSString *fileName = [[urlString componentsSeparatedByString:@"/"] lastObject];
	// 本地沙盒目录
	//NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];

	NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:fileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectoryURL path]]) {
		NSURL *localUrl = [NSURL fileURLWithPath:[documentsDirectoryURL path]];
		AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
		_playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
		_player = [AVPlayer playerWithPlayerItem:_playerItem];
		_playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
		_playerLayer.frame = CGRectMake(0, 0, self.width, self.height - 60);
		_playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		[self.layer insertSublayer:_playerLayer atIndex:0];

		[_player play];
	} else {
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		NSURL *URL = [NSURL URLWithString:urlString];
		NSURLRequest *request = [NSURLRequest requestWithURL:URL];

		[_downloadTask cancel];
		_downloadTask = [manager downloadTaskWithRequest:request
			progress:nil
			destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
			    return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
			}
			completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			    _playerItem = nil;
			    _player = nil;
			    [_playerLayer removeFromSuperlayer];
			    _playerLayer = nil;
			    if (filePath == nil)
				    return;
			    NSURL *localUrl = [NSURL fileURLWithPath:[filePath path]];
			    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
			    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
			    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
			    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
			    _playerLayer.frame = CGRectMake(0, 0, self.width, self.height - 60);
			    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
			    [self setNeedsLayout];
			    [_player play];
			}];
		[_downloadTask resume];
	}
}

- (void)createImageWithUrlString:(NSString *)urlString {
	_scanningImageView = [[UIImageView alloc] init];
	_scanningImageView.frame = self.frame;
	_scanningImageView.contentMode = UIViewContentModeScaleAspectFit;
	_scanningImageView.layer.masksToBounds = YES;
	[self addSubview:_scanningImageView];
	[_scanningImageView sd_setImageWithURL:[NSURL URLWithString:urlString]
			      placeholderImage:nil
				     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
					 _scanningImageView.centerX = SCREEN_WIDTH / 2;
					 _scanningImageView.centerY = SCREEN_HEIGHT / 2 - 60;
				     }];
}

- (void)showScanningResult:(UIButton *)sender {
	[_playerLayer removeFromSuperlayer];
	[_scanningImageView removeFromSuperview];
	// 6.捕获成功
	self.successBackgroundView = [[UIView alloc] init];
	self.successBackgroundView.backgroundColor = [UIColor colorWithHex:0x1f1f1f alpha:0.8];
	self.successBackgroundView.layer.cornerRadius = 5.0f;
	[self addSubview:self.successBackgroundView];
	[self bringSubviewToFront:self.successBackgroundView];

	NSMutableArray<UIImage *> *images = [NSMutableArray array];
	for (int i = 0; i != 18; i++) {
		UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_ar_right_answer_gif_00%02d", i]];
		[images addObject:animatedImage];
	}
	self.captureSuccessImageView = [[HTImageView alloc] init];
	self.captureSuccessImageView.animationImages = images;
	self.captureSuccessImageView.animationDuration = 0.1 * 18;
	self.captureSuccessImageView.animationRepeatCount = 1;
	[self.successBackgroundView addSubview:self.captureSuccessImageView];
	[self.captureSuccessImageView startAnimating];

	[self.successBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(self);
	    make.top.equalTo(@161);
	    make.width.equalTo(@173);
	    make.height.equalTo(@173);
	}];

	[self.captureSuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.left.equalTo(@4);
	    make.top.equalTo(@4);
	    make.width.equalTo(@165);
	    make.height.equalTo(@165);
	}];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	    [self.successBackgroundView removeFromSuperview];
	    [self onCaptureMascotSuccessful];
	});
}

- (void)onCaptureMascotSuccessful {
	for (UIView *view in KEY_WINDOW.subviews) {
		if ([view isKindOfClass:[SKScanningResultView class]]) {
			[view removeFromSuperview];
		}
	}
	//[self.successBackgroundView removeFromSuperview];

	if (_swipeType == 0) {
		SKScanningRewardView *rewardView = [[SKScanningRewardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) reward:_scanning];
		[KEY_WINDOW addSubview:rewardView];
		[KEY_WINDOW bringSubviewToFront:rewardView];
	} else {
	}
}

- (UIViewController *)activityViewController {
	UIViewController *activityViewController = nil;
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	if (window.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for (UIWindow *tmpWin in windows) {
			if (tmpWin.windowLevel == UIWindowLevelNormal) {
				window = tmpWin;
				break;
			}
		}
	}

	NSArray *viewsArray = [window subviews];
	if ([viewsArray count] > 0) {
		UIView *frontView = [viewsArray objectAtIndex:0];
		id nextResponder = [frontView nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			activityViewController = nextResponder;
		} else {
			activityViewController = window.rootViewController;
		}
	}

	return activityViewController;
}

@end
