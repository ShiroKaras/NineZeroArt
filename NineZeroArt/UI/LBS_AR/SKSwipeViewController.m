//
//  SKSwipeViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKSwipeViewController.h"
#import "HTUIHeader.h"
#import "NZPScanningFileDownloadManager.h"
#import "SKDownloadProgressView.h"
#import "SKPopupGetPuzzleView.h"
#import "SKScanningImageView.h"
#import "SKScanningPuzzleView.h"
#import "SKScanningPuzzleView.h"
#import "SKScanningRewardViewController.h"
#import <SSZipArchive/ZipArchive.h>
#import <TTTAttributedLabel.h>

#import "FXDanmaku.h"
#import "NSObject+FXAlertView.h"
#import "DemoDanmakuItemData.h"
#import "DemoDanmakuItem.h"
#import "NAClueDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

#define CurrentDevice [UIDevice currentDevice]
#define CurrentOrientation [[UIDevice currentDevice] orientation]
#define ScreenScale [UIScreen mainScreen].scale
#define NotificationCetner [NSNotificationCenter defaultCenter]

@interface SKSwipeViewController () <OpenGLViewDelegate, SKScanningRewardDelegate, SKScanningImageViewDelegate, SKScanningPuzzleViewDelegate, SKPopupGetPuzzleViewDelegate, FXDanmakuDelegate, UITextFieldDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) SKScanningImageView *scanningImageView;
@property (nonatomic, strong) SKScanningPuzzleView *scanningPuzzleView;

@property (nonatomic, strong) SKScanningRewardViewController *scanningRewardViewController;

@property (nonatomic, strong) SKDownloadProgressView *progressView;

@property (nonatomic, strong) UIButton *hintButton;
@property (nonatomic, strong) UIView *hintView;

@property (nonatomic, strong) UIButton *hintGuideImageView;

@property (nonatomic, strong) SKScanning *scanning;
@property (nonatomic, strong) NSMutableArray *rewardAction;
@property (nonatomic, assign) SKScanType swipeType; // default is SKScanTypeImage
@property (nonatomic, strong) NSMutableArray *isRecognizedTargetImage;
@property (nonatomic, strong) NSArray *linkClarity;
@property (nonatomic, strong) NSString *defaultPic;
@property (nonatomic, strong) SKReward *rewardRecord;

@property (nonatomic, strong) FXDanmaku *danmaku;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *danmakuSwitchButton;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *singleLocationManager;

@end

@implementation SKSwipeViewController {
	NSUInteger _trackedTargetId;
    BOOL danmakuSwith;
    int currentImageOrder;
    BOOL danmakuIsGet;
    BOOL startFlag;
    
    CLLocation *_currentLocation;
    CLLocationCoordinate2D _testMascotPoint;
    float mDistance;
}

- (instancetype)initWithScanning:(SKScanning*)scanning {
	if (self = [super init]) {
        startFlag = false;
		_swipeType = SKScanTypeImage;
        self.scanning = scanning;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    currentImageOrder = -1;
    
    [self registerLocation];    //注册地图服务
    [self createUI];
    
    [self setupDanmaku];
    
	if (!NO_NETWORK) {
		[self loadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningImageView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self.glView pause];
}

- (void)dealloc {
    [self.glView stop];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self.glView resize:self.view.bounds orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.glView setOrientation:toInterfaceOrientation];
}

- (void)createUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createBottomView];
}

- (void)createBottomView {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom-49, SCREEN_WIDTH, 49)];
    [self.view addSubview:self.bottomView];
    
    _danmakuSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.width-13-27, 11, 27, 27)];
    [_danmakuSwitchButton setBackgroundImage:[UIImage imageNamed:@"btn_ar_shieldbarrage"] forState:UIControlStateNormal];
    [_danmakuSwitchButton setBackgroundImage:[UIImage imageNamed:@"btn_ar_shieldbarrage_highlight"] forState:UIControlStateHighlighted];
    [_danmakuSwitchButton addTarget:self action:@selector(danmakuSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_danmakuSwitchButton];
    danmakuSwith = YES;
    
    _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 7, self.bottomView.width-14-13-27-14, 35)];
    _commentTextField.delegate = self;
    _commentTextField.layer.cornerRadius = 5;
    _commentTextField.layer.borderWidth = 1;
    _commentTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _commentTextField.returnKeyType = UIReturnKeySend;
    _commentTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 60)];
    _commentTextField.leftViewMode = UITextFieldViewModeAlways;
    [_commentTextField setTextColor:[UIColor whiteColor]];
    _commentTextField.font = PINGFANG_FONT_OF_SIZE(12);
    NSMutableParagraphStyle *style = [_commentTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = _commentTextField.font.lineHeight - (_commentTextField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    _commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"我也来评论下..."
                                                                              attributes:@{
                                                                                           NSForegroundColorAttributeName:COMMON_TEXT_2_COLOR,
                                                                                           NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                                                                           NSParagraphStyleAttributeName : style
                                                                                           }];
    [self.bottomView addSubview:_commentTextField];
    self.commentTextField.hidden = YES;
    self.danmakuSwitchButton.hidden = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_commentTextField resignFirstResponder];
}

- (void)danmakuSwitchButtonClick:(UIButton*)sender {
    danmakuSwith = !danmakuSwith;
    if (danmakuSwith) {
        self.danmaku.hidden = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_ar_shieldbarrage"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_ar_shieldbarrage_highlight"] forState:UIControlStateHighlighted];
    } else {
        self.danmaku.hidden = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_ar_barrage"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_ar_barrage_highlight"] forState:UIControlStateHighlighted];
    }
}

- (void)didClickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if (_commentTextField.text.length > 11) {
        _commentTextField.text = [_commentTextField.text substringToIndex:11];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.frame = CGRectMake(0, self.view.height - keyboardRect.size.height-49, self.view.width, 49);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.bottomView.frame = CGRectMake(0, self.view.height-49, self.view.width, 49);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_commentTextField resignFirstResponder];

    if ([_commentTextField.text isEqualToString:@""]) {
        [self showTipsWithText:@"评论不能为空~"];
    }
    
    [[[SKServiceManager sharedInstance] scanningService] sendScanningComment:_commentTextField.text imageID:self.scanning.lid[currentImageOrder] callback:^(BOOL success, SKResponsePackage *response) {
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 186*0.6+30, 96, 30)];
        item.layer.cornerRadius = 15;
        item.backgroundColor = COMMON_GREEN_COLOR;
        [self.view addSubview:item];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [item addSubview:avatarImageView];
        avatarImageView.layer.cornerRadius = 10;
        avatarImageView.layer.masksToBounds = YES;
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[SKStorageManager sharedInstance].getLoginUser.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text =  _commentTextField.text;
        contentLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [contentLabel sizeToFit];
        [item addSubview:contentLabel];
        contentLabel.left = avatarImageView.right+8;
        contentLabel.centerY = item.height/2;
        
        item.width = contentLabel.width+16+20+5;
        item.left = self.view.right;
        
        [self.view addSubview:item];
        [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            item.right = 0;
        } completion:^(BOOL finished) {
            [item removeFromSuperview];
        }];
        
        _commentTextField.text = @"";
        
    }];
    return YES;
}

#pragma mark - Location

- (void)registerLocation {
    self.singleLocationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.singleLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.singleLocationManager.locationTimeout = 2;
    //   逆地理请求超时时间，可修改，最小2s
    self.singleLocationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）
    [self.singleLocationManager requestLocationWithReGeocode:YES
                                             completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                                 if (error) {
                                                     DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                                                 }
                                                 _testMascotPoint = [self getCurrentLocationWith:location];
                                                 
                                                 self.locationManager = [[AMapLocationManager alloc] init];
                                                 self.locationManager.delegate = self;
                                                 [self.locationManager startUpdatingLocation];
                                                 
                                             }];
}


- (CLLocationCoordinate2D)getCurrentLocationWith:(CLLocation *)location {
    CLLocationDistance currentDistance = -1;
    CLLocationCoordinate2D currentPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    //悠唐国际 坐标
    double lat = 39.9213000000;
    double lng = 116.4404200000;
    
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lng));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
    
    if (currentDistance < 0 || distance < currentDistance) {
        currentDistance = distance;
        currentPoint = CLLocationCoordinate2DMake(lat, lng);
    }
    
    startFlag = true;
    return currentPoint;
}

#pragma mark - AMapDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    if (startFlag) {
        _currentLocation = location;
        
        CLLocationDistance currentDistance = -1;
        CLLocationCoordinate2D currentPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        //悠唐国际 坐标
        double lat = 39.9213000000;
        double lng = 116.4404200000;
        
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lng));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);
        
        if (currentDistance < 0 || distance < currentDistance) {
            currentDistance = distance;
            currentPoint = CLLocationCoordinate2DMake(lat, lng);
        }
        mDistance = currentDistance;
        NSLog(@"Distance: %f", currentDistance);
        
    }
}

#pragma mark - Danmaku Views
- (void)setupDanmaku {
    self.danmaku = [[FXDanmaku alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 186*0.6)];
    [self.view addSubview:self.danmaku];
    
    FXDanmakuConfiguration *config = [FXDanmakuConfiguration defaultConfiguration];
    config.rowHeight = [DemoDanmakuItem itemHeight];
    self.danmaku.configuration = config;
    self.danmaku.delegate = self;
    [self.danmaku registerNib:[UINib nibWithNibName:NSStringFromClass([DemoDanmakuItem class]) bundle:nil]
       forItemReuseIdentifier:[DemoDanmakuItem reuseIdentifier]];
}

#pragma mark  Observer
- (void)setupObserver {
    [NotificationCetner addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [NotificationCetner addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self.danmaku start];
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    [self.danmaku pause];
}

#pragma mark  FXDanmakuDelegate
- (void)danmaku:(FXDanmaku *)danmaku didClickItem:(FXDanmakuItem *)item withData:(DemoDanmakuItemData *)data {
    
}

#pragma mark -
//Load data

- (void)loadData {
    self.swipeType = SKScanTypeImage;
    if (self.scanning.bstatus == NO) {
        self.danmaku.hidden = YES;
        self.bottomView.hidden = YES;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [self setupScanningFile:self.scanning
          completionHandler:^{
              __strong __typeof__(self) strongSelf = weakSelf;
              switch (_swipeType) {
                  case SKScanTypeImage: {
                      strongSelf.scanningImageView = [[SKScanningImageView alloc] initWithFrame:self.view.frame];
                      strongSelf.scanningImageView.delegate = strongSelf;
                      [strongSelf.view insertSubview:strongSelf.scanningImageView atIndex:1];
                      
                      break;
                  }
                  default:
                      break;
              }
          }];
}

- (void)setupScanningFile:(SKScanning *)scanning completionHandler:(void (^)())completionHandler {
	if (scanning.hint && scanning.hint.length > 0) {
		[self setupHintButton];
	}

	NSMutableArray *array = [NSMutableArray arrayWithCapacity:_rewardAction.count];
	for (int i = 0; i < _rewardAction.count; i++) {
		[array addObject:[NSNumber numberWithBool:false]];
	}
	self.isRecognizedTargetImage = array;

	if (![NZPScanningFileDownloadManager isZipFileExistsWithFileName:scanning.file_url]) {
		// 文件不存在，需要下载
		[self setupProgressView];

		[NZPScanningFileDownloadManager downloadZip:scanning.file_url
			progress:^(NSProgress *downloadProgress) {
			    // 更新进度条
			    dispatch_async(dispatch_get_main_queue(), ^{
				[self.progressView setProgressViewPercent:downloadProgress.fractionCompleted];
			    });
			}
			completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			    if (!error) {
				    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
				    NSURL *unzipFilesPath = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
				    unzipFilesPath = [unzipFilesPath URLByAppendingPathComponent:fileName];

				    [SSZipArchive unzipFileAtPath:filePath.relativePath
					    toDestination:unzipFilesPath.relativePath
					    overwrite:YES
					    password:nil
					    progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
					    }
					    completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error) {
						dispatch_async(dispatch_get_main_queue(), ^{
						    [self.progressView removeFromSuperview];
						    self.progressView = nil;
						});
						if (succeeded) {
							// 加载识别图
							[self setupOpenGLViewWithTargetNumber:scanning.link_url.count];
							[self.glView startWithFileName:scanning.file_url videoURLs:scanning.link_url sid:scanning.sid pidArray:scanning.lid];
							completionHandler();
						} else {
							NSLog(@"zip解压失败:%@", error);
						}

					    }];
			    } else {
				    NSLog(@"识别图下载失败:%@", error);
			    }

			}];
    } else if (![NZPScanningFileDownloadManager isUnZipFileExistsWithFileName:scanning.file_url]) {
		// zip已下载但是解压文件不存在
		NSString *unzipFilePath = [[scanning.file_url lastPathComponent] stringByDeletingPathExtension];
		NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
		unzipFilePath = [documentsDirectoryURL URLByAppendingPathComponent:unzipFilePath].relativePath;
		NSString *zipFileAtPath = [documentsDirectoryURL URLByAppendingPathComponent:scanning.file_url].relativePath;

		[SSZipArchive unzipFileAtPath:zipFileAtPath
			toDestination:unzipFilePath
			overwrite:YES
			password:nil
			progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {

			}
			completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error) {
			    // 加载识别图
			    [self setupOpenGLViewWithTargetNumber:scanning.link_url.count];
			    [self.glView startWithFileName:scanning.file_url videoURLs:scanning.link_url sid:scanning.sid pidArray:scanning.lid];
			    completionHandler();
			}];
	} else {
		// 直接加载识别图
		[self setupOpenGLViewWithTargetNumber:scanning.link_url.count];
		[self.glView startWithFileName:scanning.file_url videoURLs:scanning.link_url sid:scanning.sid pidArray:scanning.lid];
		completionHandler();
	}
}

- (void)setupOpenGLViewWithTargetNumber:(NSUInteger)targetNumber {
	if (!_glView) {
		self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds withSwipeType:_swipeType targetsCount:(int)targetNumber];
		self.glView.delegate = self;
		[self.view insertSubview:_glView atIndex:0];
		[self.glView setOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	}
}

- (void)setupProgressView {
	//进度条
	_progressView = [[SKDownloadProgressView alloc] init];
	_progressView.center = self.view.center;
	[self.view addSubview:_progressView];
}

- (void)setupHintButton {
	if (FIRST_LAUNCH_SWIPEVIEW) {
		_hintButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
		_hintButton.right = self.view.right - 4.f;
		_hintButton.top = self.view.top + 12.f;
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule"] forState:UIControlStateNormal];
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule_highlight"] forState:UIControlStateHighlighted];
		[_hintButton addTarget:self action:@selector(showHintView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintButton];

		_hintGuideImageView = [[UIButton alloc] initWithFrame:self.view.frame];

		UIImage *backgroundImage;
		if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_640"];
		} else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_750"];
		} else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_1242"];
		}

		[_hintGuideImageView setImage:backgroundImage forState:UIControlStateNormal];
		[_hintGuideImageView addTarget:self action:@selector(hideHintGuideView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintGuideImageView];
		_hintGuideImageView.alpha = 0;

		UILabel *hintGuideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12.5f)];
		hintGuideLabel.text = @"点击任意区域关闭";
		hintGuideLabel.textAlignment = NSTextAlignmentCenter;
		hintGuideLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
		hintGuideLabel.font = PINGFANG_FONT_OF_SIZE(12.f);
		hintGuideLabel.alpha = 0;
		hintGuideLabel.bottom = self.view.bottom - 16.f;
		hintGuideLabel.centerX = self.view.centerX;
		[_hintGuideImageView addSubview:hintGuideLabel];

		[UIView animateWithDuration:0.5f
				 animations:^{
				     _hintGuideImageView.alpha = 1.0f;
				     hintGuideLabel.alpha = 1.0f;
				 }];

		LAUNCHED_SWIPEVIEW
	} else {
		_hintButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
		_hintButton.right = self.view.right - 4.f;
		_hintButton.top = self.view.top + 12.f;
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule"] forState:UIControlStateNormal];
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule_highlight"] forState:UIControlStateHighlighted];
		[_hintButton addTarget:self action:@selector(showHintView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintButton];
	}
}

- (void)showHintView {
	[_glView pause];

	if (!_hintView) {
		_hintView = [[UIView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:_hintView];

		CALayer *backGroundLayer = [[CALayer alloc] init];
		backGroundLayer.frame = SCREEN_BOUNDS;
		backGroundLayer.backgroundColor = [UIColor colorWithHex:0x000000].CGColor;
		backGroundLayer.opacity = 0.8;
		[_hintView.layer addSublayer:backGroundLayer];

		UIButton *closeButton = [[UIButton alloc] init];
		[closeButton addTarget:self action:@selector(hideHintView) forControlEvents:UIControlEventTouchDown];
		[closeButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
		[_hintView addSubview:closeButton];
		[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@40);
		    make.height.equalTo(@40);
		    make.top.equalTo(@12);
		    make.left.equalTo(@4);
		}];

		TTTAttributedLabel *hintLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(40.f, 0, SCREEN_WIDTH - 80, 0)];
		hintLabel.textAlignment = NSTextAlignmentLeft;
		hintLabel.numberOfLines = 0;
		hintLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
		hintLabel.font = PINGFANG_FONT_OF_SIZE(10.0);
		hintLabel.lineSpacing = 2.0f;
		hintLabel.text = self.scanning.hint;
		[_hintView addSubview:hintLabel];
		[hintLabel sizeToFit];
        
		hintLabel.centerY = self.view.centerY;
        
		CALayer *hintImageLayer = [[CALayer alloc] init];
		hintImageLayer.frame = CGRectMake((SCREEN_WIDTH - 253) / 2.f, hintLabel.top - 92.f - 20.f, 253, 92);
		hintImageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"img_scanning_rule"].CGImage);
		[_hintView.layer addSublayer:hintImageLayer];

		CALayer *hintBackGroundLayer = [[CALayer alloc] init];
		hintBackGroundLayer.frame = CGRectMake(20.f, hintLabel.frame.origin.y - 57.f, SCREEN_WIDTH - 40.f, hintLabel.height + 20.f + 20.f + 35.f);
		hintBackGroundLayer.backgroundColor = [UIColor colorWithHex:0x1F1F1F].CGColor;
		hintBackGroundLayer.cornerRadius = 5;
		hintBackGroundLayer.shouldRasterize = YES;
		[_hintView.layer insertSublayer:hintBackGroundLayer below:hintLabel.layer];
	}

	_hintView.alpha = 0;

	[UIView animateWithDuration:0.5f
			 animations:^{
			     _hintView.alpha = 1.0f;
			 }];
}

- (void)hideHintGuideView {
	[_hintGuideImageView removeFromSuperview];
	_hintGuideImageView = nil;
}

- (void)hideHintView {
	[UIView animateWithDuration:0.5f
		animations:^{
		    _hintView.alpha = 0;
		}
		completion:^(BOOL finished) {
		    [_hintView removeFromSuperview];
		    _hintView = nil;
		    [_glView restart];
		}];
}

- (void)onCaptureMascotSuccessful {
	[self.delegate didClickBackButtonInScanningResultView:self];
}

#pragma SKScanningImageViewDelegate

- (void)scanningImageView:(SKScanningImageView *)imageView didTapGiftButton:(id)giftButton {
	[imageView removeGiftView];
	SKScanningRewardViewController *controller = [[SKScanningRewardViewController alloc] initWithRewardID:self.scanning.reward_id sId:self.scanning.sid scanType:_swipeType];
	controller.delegate = self;
	[self presentViewController:controller animated:NO completion:nil];
    
    NAClueDetailViewController* oneVC =nil;
    for(UIViewController* VC in self.navigationController.viewControllers){
        if([VC isKindOfClass:[NAClueDetailViewController class]]){
            oneVC =(NAClueDetailViewController*) VC;
            oneVC.scanning.is_haved_ticket = YES;
        }
    }
}

#pragma mark - OpenGLViewDelegate

- (void)isRecognizedTarget:(BOOL)flag targetId:(int)targetId {
    if (mDistance>300) {
        return;
    }
    
	if (flag && targetId >= 0) {
        //扫到目标图
        [self.scanningImageView.scanningGridLine setHidden:YES];
        self.danmaku.hidden = NO;
		if (_swipeType == SKScanTypeImage) {
            if (self.scanning.reward_id && ![self.scanning.reward_id isEqualToString:@"0"] && !self.scanning.is_haved_ticket) {
                _trackedTargetId = targetId;
                [_scanningImageView setUpGiftView];
                [_scanningImageView pushGift];
            }
            self.commentTextField.hidden = NO;
            self.danmakuSwitchButton.hidden = NO;
            if (targetId!=currentImageOrder) {
                if (!danmakuIsGet) {
                    danmakuIsGet = YES;
                    [self.danmaku emptyData];
                    [self.danmaku cleanScreen];
                    [self.danmaku stop];
                    [[[SKServiceManager sharedInstance] scanningService] getScanningBarrageWithImageID:self.scanning.lid[targetId] callback:^(BOOL success, NSArray<SKDanmakuItem *> *danmakuList) {
                        [self.danmaku start];
                        for (SKDanmakuItem *danmaku in danmakuList) {
                            DemoDanmakuItemData *data = [DemoDanmakuItemData data];
                            data.avatarName = danmaku.user_avatar;
                            data.desc = danmaku.contents;
                            data.user_id = danmaku.user_id;
                            if ([danmaku.user_id isEqualToString:[[SKStorageManager sharedInstance] getUserID]]) {
                                data.backColor = COMMON_GREEN_COLOR;
                            } else {
                                data.backColor = COMMON_TITLE_BG_COLOR;
                            }
                            [self.danmaku addData:data];
                        }
                        
                        if (!self.danmaku.isRunning) {
                            [self.danmaku start];
                        }
                    }];
                }
                currentImageOrder = targetId;
            }
		}
	} else {
        //未扫到目标图
        danmakuIsGet = NO;
        [self.scanningImageView showScanningGridLine];
		if (_swipeType == SKScanTypeImage) {
            self.danmaku.hidden = YES;
            self.commentTextField.hidden = YES;
            self.danmakuSwitchButton.hidden = YES;
		}
	}
}

#pragma mark - SKScanningRewardDelegate
- (void)didClickBackButtonInScanningCaptureController:(SKScanningRewardViewController *)controller {
    [controller dismissViewControllerAnimated:NO completion:^{
        [self.glView restart];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - SKScanningPuzzleViewDelegate
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapExchangeButton:(UIButton *)button {
	// 兑换
	_scanningRewardViewController = [[SKScanningRewardViewController alloc] initWithRewardID:self.scanning.reward_id sId:self.scanning.sid scanType:_swipeType];
	_scanningRewardViewController.delegate = self;
	[self.view addSubview:_scanningRewardViewController.view];
}

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapBoxButton:(UIButton *)button {
	// 点开宝箱
	[_scanningPuzzleView hideBoxView];

	[[[SKServiceManager sharedInstance] scanningService] getScanningPuzzleWithMontageId:[self.scanning.link_url objectAtIndex:_trackedTargetId]
											sId:self.scanning.sid
										   callback:^(BOOL success, SKResponsePackage *response) {
										       NSLog(@"%@", response);
										       if (success && response.result == 0) {
											       SKPopupGetPuzzleView *puzzleView = [[SKPopupGetPuzzleView alloc] initWithPuzzleImageURL:[self.scanning.link_url objectAtIndex:_trackedTargetId]];
											       puzzleView.delegate = self;
											       [self.view addSubview:puzzleView];

											       _rewardAction[_trackedTargetId] = @"1";

										       } else {
											       NSLog(@"获取拼图碎片失败");
											       [_glView restart];
											       [_scanningPuzzleView showAnimationView];
											       [_scanningPuzzleView showPuzzleButton];
										       }
										   }];
}

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view isShowPuzzles:(BOOL)isShowPuzzles {
	if (isShowPuzzles) {
		[_glView pause];
	} else {
		[_glView restart];
	}

	if (!_rewardRecord) {
		[_scanningPuzzleView setupPuzzleView];
	} else {
		[_scanningPuzzleView hideAnimationView];
		[_scanningPuzzleView hidePuzzleButton];

		_scanningRewardViewController = [[SKScanningRewardViewController alloc] initWithReward:_rewardRecord];
		_scanningRewardViewController.delegate = self;
		[self.view addSubview:_scanningRewardViewController.view];
	}
}

#pragma mark SKPopupGetPuzzleViewDelegate
- (void)didRemoveFromSuperView {
	[_glView restart];
	[_scanningPuzzleView showAnimationView];
	[_scanningPuzzleView showPuzzleButton];
}

@end
