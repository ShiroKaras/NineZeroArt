//
//  HTARCaptureController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/16.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTARCaptureController.h"
#import "CommonUI.h"
#import <Masonry.h>
#include <stdlib.h>

#import "HTUIHeader.h"
#import "MBProgressHUD+BWMExtension.h"
#import "SKHelperView.h"
#import <UIImage+animatedGIF.h>

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

NSString *kTipCloseMascot = @"正在靠近藏匿零仔";
NSString *kTipTapMascotToCapture = @"快点击零仔进行捕获";

@interface HTARCaptureController () <PRARManagerDelegate, AMapLocationManagerDelegate, HTAlertViewDelegate>
@property (nonatomic, strong) PRARManager *prARManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *mascotImageView;
//@property (nonatomic, strong) MotionEffectView *mascotMotionView;
@property (nonatomic, strong) HTImageView *captureSuccessImageView;
@property (nonatomic, strong) UIView *successBackgroundView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *singleLocationManager;
@property (nonatomic, strong) UIButton *helpButton;
//@property (nonatomic, strong) SKHelperGuideView *guideView;
//@property (nonatomic, strong) SKHelperScrollView *helpView;

@property (nonatomic, strong) NSArray *locationPointArray;

@property (nonatomic, assign) NZLbsType type;   //1.限时获取
@property (nonatomic, strong) SKStrongholdItem *strongholdItem;

@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, assign) BOOL isShowedPrompt;  //是否已提示过捕捉
@property (nonatomic, strong) NSString *sid;    //活动ID;
@end

@implementation HTARCaptureController {
	CLLocation *_currentLocation;
	CLLocationCoordinate2D _testMascotPoint;
	BOOL _needShowDebugLocation;
	UIView *_arView;
	BOOL startFlag;
}


- (instancetype)init {
    if (self = [super init]) {
        _type = NZLbsTypeDefault;
    }
    return self;
}

- (instancetype)initWithQuestion:(SKQuestion *)question {
	if (self = [super init]) {
        _type = NZLbsTypeQuestion;
		_question = question;
		startFlag = false;
		self.locationPointArray = question.question_location;
		if (_question.question_location.count > 0) {
			for (NSDictionary *locationDict in _question.question_location) {
				double lat = [[NSString stringWithFormat:@"%@", locationDict[@"lat"]] doubleValue];
				double lng = [[NSString stringWithFormat:@"%@", locationDict[@"lng"]] doubleValue];
				DLog(@"lat=>%f \n lng=>%f", lat, lng);
			}
		}
	}
	return self;
}

- (instancetype)initWithStronghold:(SKStrongholdItem*)stronghold {
    if (self = [super init]) {
        _type = NZLbsTypeStronghold;
        _strongholdItem = stronghold;
        startFlag = false;
        NSDictionary *locationDict = @{
                                       @"lat" : stronghold.lat,
                                       @"lng" : stronghold.lng
                                       };
        self.locationPointArray = @[locationDict];
    }
    return self;
}

- (instancetype)initWithHomepageWithPetgif:(NSString*)petgif {
    if (self = [super init]) {
        _type = NZLbsTypeHomepage;
        _pet_gif = petgif;
        [[[SKServiceManager sharedInstance] scanningService] getScanningWithCallBack:^(BOOL success, SKResponsePackage *package) {
            self.locationPointArray = package.data[@"scanning_lbs_locations"];
            self.isHadReward = [package.data[@"is_haved_reward"] boolValue];
            self.rewardID = package.data[@"reward_id"];
            self.sid = package.data[@"sid"];
            //判断GPS是否开启
            HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
            alertView.delegate = self;
            if ([CLLocationManager locationServicesEnabled]) {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                    [self createUI];
                } else {
                    [alertView show];
                }
            } else {
                [alertView show];
            }
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.prARManager stopAR];
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {
    
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
    
    if (_type == NZLbsTypeDefault ||
        _type == NZLbsTypeQuestion ||
        _type == NZLbsTypeStronghold) {
        //判断GPS是否开启
        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
        alertView.delegate = self;
        if ([CLLocationManager locationServicesEnabled]) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                [self createUI];
            } else {
                [alertView show];
            }
        } else {
            [alertView show];
        }
    }
}

- (void)createUI {
    _needShowDebugLocation = NO;
    _isShowedPrompt = NO;
    
    [self registerLocation];
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:NO];
    
    // 2.返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    [self.view addSubview:self.backButton];
    
    // 3.雷达
    NSInteger radarCount = 50;
    NSMutableArray *radars = [NSMutableArray arrayWithCapacity:radarCount];
    for (int i = 0; i != radarCount; i++) {
        [radars addObject:[UIImage imageNamed:[NSString stringWithFormat:@"raw_radar_gif_000%02d", i]]];
    }
    self.radarImageView = [[UIImageView alloc] init];
    self.radarImageView.layer.masksToBounds = YES;
    self.radarImageView.animationImages = radars;
    self.radarImageView.animationDuration = 2.0f;
    self.radarImageView.animationRepeatCount = 0;
    [self.radarImageView startAnimating];
    self.radarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShowDebug)];
    tapThree.numberOfTapsRequired = 1;
    [self.radarImageView addGestureRecognizer:tapThree];
    [self.view addSubview:self.radarImageView];
    
    
    // 4.提示 (3.0版本不显示)
    self.tipImageView = [[UIImageView alloc] init];
    self.tipImageView.layer.masksToBounds = YES;
    self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
    self.tipImageView.contentMode = UIViewContentModeBottom;
    [self.tipImageView sizeToFit];
    [self.view addSubview:self.tipImageView];
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
    [self.tipImageView addSubview:self.tipLabel];
    [self showtipImageView];
    self.tipImageView.alpha = 0;
//    self.tipImageView.hidden = YES;
    
    // 3.0版提示
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.width, 64)];
    self.promptView.backgroundColor = COMMON_GREEN_COLOR;
    [self.view addSubview:self.promptView];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_arpage_prompt"]];
    [self.promptView addSubview:promptImageView];
    [promptImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.promptView);
    }];
    if (_type == NZLbsTypeDefault && _isHadReward==NO) {
        self.radarImageView.hidden = YES;
        [self showPromptView];
    }
    
    //1.首页 2.题目 3.据点 4.首页LBS
    NSString *unzipFilesPath;
    if (_type == NZLbsTypeDefault || _type == NZLbsTypeHomepage) {
        NSLog(@"%@", self.pet_gif);
        unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [self.pet_gif stringByDeletingPathExtension]]];
    } else if (_type == NZLbsTypeQuestion) {
        unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [self.question.question_ar_pet stringByDeletingPathExtension]]];
    } else if (_type == NZLbsTypeStronghold) {
        unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [self.strongholdItem.pet_gif stringByDeletingPathExtension]]];
    }
    
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator = [myFileManager enumeratorAtPath:unzipFilesPath];
    //列举目录内容，可以遍历子目录
    NSString *unzipFileName;
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    while ((unzipFileName = [myDirectoryEnumerator nextObject]) != nil) {
        NSData *data = [NSData dataWithContentsOfFile:[unzipFilesPath stringByAppendingPathComponent:unzipFileName]];
        UIImage *image = [UIImage imageWithData:data];
        [images addObject:image];
    }
    self.mascotImageView = [[UIImageView alloc] init];
    self.mascotImageView.layer.masksToBounds = YES;
    self.mascotImageView.hidden = (_type==NZLbsTypeDefault)|(_type==NZLbsTypeHomepage)? _isHadReward:YES;
    self.mascotImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.mascotImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMascot)];
    [self.mascotImageView addGestureRecognizer:tap];
    self.mascotImageView.animationImages = images;
    self.mascotImageView.animationDuration = 0.1 * images.count;
    self.mascotImageView.animationRepeatCount = 0;
    [self.mascotImageView startAnimating];
    
    if ((_type==NZLbsTypeDefault)&&_isHadReward == YES) {
        self.mascotImageView.hidden = YES;
    } else if (_type==NZLbsTypeHomepage) {
        self.mascotImageView.hidden = YES;
    }
    
    if (FIRST_LAUNCH_AR && _type == NZLbsTypeStronghold) {
        EVER_LAUNCH_AR
        SKHelperGuideView *helperView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperGuideViewTypeLBS];
        [KEY_WINDOW addSubview:helperView];
    }
    
    [self buildConstrains];
}

- (void)didClickOKButton {
    [self.promptView removeFromSuperview];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showtipImageView {
	self.tipImageView.alpha = 1.0;
	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hidetipImageView) userInfo:nil repeats:NO];
}

- (void)hidetipImageView {
	[UIView animateWithDuration:0.3
			 animations:^{
			     self.tipImageView.alpha = 0;
			 }];
}

- (void)showPromptView {
    _isShowedPrompt = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        self.promptView.top = 0;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.3 delay:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.promptView.top = -64;
        } completion:^(BOOL finished) {
            [self.promptView removeFromSuperview];
        }];
    }];
}

- (void)buildConstrains {
	[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.left.equalTo(@11);
	    make.bottom.equalTo(@(-11));
	}];

	[self.radarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.top.equalTo(@31);
	    make.right.equalTo(@(-11));
	    make.width.equalTo(@(90));
	    make.height.equalTo(@(90));
	}];

	[self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.bottom.equalTo(@(-55));
	    make.centerX.equalTo(self.view);
	    make.width.equalTo(@(288));
	    make.height.equalTo(@(86));
	}];

	[self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(self.tipImageView);
	    make.bottom.equalTo(self.tipImageView.mas_bottom).offset(-27);
	}];

	[self.mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerY.equalTo(self.view);
	    make.centerX.equalTo(self.view);
	    make.width.equalTo(self.view);
	    make.height.equalTo(self.view.mas_width);
	}];

	[self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.top.equalTo(@10);
	    make.left.equalTo(@10);
	}];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

//- (void)showGuideviewWithType:(SKHelperGuideViewType)type {
//	_guideView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:type];
//	[KEY_WINDOW addSubview:_guideView];
//	[KEY_WINDOW bringSubviewToFront:_guideView];
//}

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

	for (NSDictionary *dict in self.locationPointArray) {
        double lat, lng;
        if (_type == NZLbsTypeHomepage) {
            lat = [dict[@"latitude"] doubleValue];
            lng = [dict[@"longitude"] doubleValue];
        } else {
            lat = [dict[@"lat"] doubleValue];
            lng = [dict[@"lng"] doubleValue];
        }
		//1.将两个经纬度点转成投影点
		MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lng));
		MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
		//2.计算距离
		CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);

		if (currentDistance < 0 || distance < currentDistance) {
			currentDistance = distance;
			currentPoint = CLLocationCoordinate2DMake(lat, lng);
		}
	}
	startFlag = true;
	return currentPoint;
}

//#pragma MotionEffectViewDelegate
//
//- (void)didTapMotionEffectView:(MotionEffectView *)view {
//    [self onClickMascot];
//}

#pragma mark - AMapDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
	if (startFlag) {
        _currentLocation = location;
        [self.prARManager startARWithData:[self getDummyData] forLocation:location.coordinate];
    }
}

#pragma mark - Action

//- (void)arQuestionHelpButtonClick:(UIButton *)sender {
//	[TalkingData trackEvent:@"vrtips"];
//	_helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeAR];
//	_helpView.scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT - 356) / 2, 0, 0);
//	_helpView.dimmingView.alpha = 0;
//	[self.view addSubview:_helpView];
//
//	[UIView animateWithDuration:0.3
//			      delay:0
//			    options:UIViewAnimationOptionCurveEaseOut
//			 animations:^{
//			     _helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//			     _helpView.dimmingView.alpha = 0.9;
//			 }
//			 completion:^(BOOL finished){
//
//			 }];
//}

- (void)onClickBack {
	//    [self.mascotMotionView disableMotionEffect];
	//    [self.mascotMotionView removeFromSuperview];
	//    self.mascotMotionView = nil;
    [self.promptView removeFromSuperview];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCaptureMascotSuccessfulWithReward:(SKReward *)reward {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInARCaptureController:reward:)]) {
        [self.delegate didClickBackButtonInARCaptureController:self reward:reward];
    }
}

- (void)onClickMascot {
//	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    if (_type==NZLbsTypeDefault) {
        [[[SKServiceManager sharedInstance] scanningService] getTimeSlotRewardDetailWithRewardID:self.rewardID callback:^(BOOL success, SKResponsePackage *response) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (success) {
                [self catchSuccess];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.05 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.successBackgroundView removeFromSuperview];
                    [self onCaptureMascotSuccessfulWithReward:[SKReward mj_objectWithKeyValues:[response.data mj_keyValues]]];
                });
            } else {
                if (response.result) {
                    [self showTipsWithText:[NSString stringWithFormat:@"异常%ld", (long)response.result]];
                } else {
                    [self showTipsWithText:@"异常"];
                }
            }
        }];
    } else if (_type==NZLbsTypeQuestion) {
        [[[SKServiceManager sharedInstance] answerService] answerLBSQuestionWithLocation:_currentLocation callback:^(BOOL success, SKResponsePackage *response) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (success && response.result == 0) {
                [self catchSuccess];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.05 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.successBackgroundView removeFromSuperview];
                    [self onCaptureMascotSuccessfulWithReward:[SKReward mj_objectWithKeyValues:[response.data mj_keyValues]]];
                });
                
            } else {
                if (response.result) {
                    [self showTipsWithText:[NSString stringWithFormat:@"异常%ld", (long)response.result]];
                } else {
                    [self showTipsWithText:@"异常"];
                }
            }
        }];
    } else if (_type == NZLbsTypeStronghold) {    //据点
        [[[SKServiceManager sharedInstance] strongholdService] scanningWithStronghold:_strongholdItem forLoacation:_currentLocation callback:^(BOOL success, SKResponsePackage *response) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (success && response.result == 0) {
                [self catchSuccess];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.05 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.successBackgroundView removeFromSuperview];
                    [self onCaptureMascotSuccessfulWithReward:[SKReward mj_objectWithKeyValues:[response.data mj_keyValues]]];
                });
            } else {
                if (response.result) {
                    [self showTipsWithText:[NSString stringWithFormat:@"异常%ld", (long)response.result]];
                } else {
                    [self showTipsWithText:@"异常"];
                }
            }
        }];
    } else if (_type==NZLbsTypeHomepage) {
        [[[SKServiceManager sharedInstance] scanningService] getLbsRewardDetailWithID:self.rewardID sid:self.sid callback:^(BOOL success, SKResponsePackage *response) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (success) {
                [self catchSuccess];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.05 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.successBackgroundView removeFromSuperview];
                    [self onCaptureMascotSuccessfulWithReward:[SKReward mj_objectWithKeyValues:[response.data mj_keyValues]]];
                });
            } else {
                if (response.result) {
                    [self showTipsWithText:[NSString stringWithFormat:@"异常%ld", (long)response.result]];
                } else {
                    [self showTipsWithText:@"异常"];
                }
            }
        }];
    }
}

- (void)catchSuccess {
    // 6.捕获成功
    self.successBackgroundView = [[UIView alloc] init];
    self.successBackgroundView.backgroundColor = [UIColor colorWithHex:0x1f1f1f alpha:0.8];
    self.successBackgroundView.layer.cornerRadius = 5.0f;
    [self.view addSubview:self.successBackgroundView];
    [self.view bringSubviewToFront:self.successBackgroundView];
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 0; i != 18; i++) {
        UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_ar_right_answer_gif_00%02d", i]];
        [images addObject:animatedImage];
    }
    self.captureSuccessImageView = [[HTImageView alloc] init];
    self.captureSuccessImageView.animationImages = images;
    self.captureSuccessImageView.animationDuration = 0.05 * 18;
    self.captureSuccessImageView.animationRepeatCount = 1;
    [self.successBackgroundView addSubview:self.captureSuccessImageView];
    [self.captureSuccessImageView startAnimating];
    
    [self.successBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
        make.width.equalTo(@173);
        make.height.equalTo(@173);
    }];
    
    [self.captureSuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@4);
        make.top.equalTo(@4);
        make.width.equalTo(@165);
        make.height.equalTo(@165);
    }];
    
    [self.mascotImageView removeFromSuperview];
}

- (void)onClickShowDebug {
    if (_type == NZLbsTypeDefault) return;
    
	self.tipLabel.text = @"";
	_needShowDebugLocation = YES;
	[self showtipImageView];
	[self.view addSubview:_arView];
}

#pragma mark - Dummy AR Data

- (NSArray *)getDummyData {
	if (_testMascotPoint.latitude == 0 && _testMascotPoint.longitude == 0) {
		_testMascotPoint = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude + 0.0000001, _currentLocation.coordinate.longitude + 0.0000001);
	}
	NSDictionary *point = [self createPointWithId:0 at:_testMascotPoint];
	return @[point];
}

- (NSDictionary *)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates {
	NSDictionary *point = @{
		@"id": @(the_id),
		@"title": [NSString stringWithFormat:@"坐标%d", the_id],
		@"lon": @(locCoordinates.longitude),
		@"lat": @(locCoordinates.latitude)
	};
	return point;
}

#pragma mark - PRARManager Delegate

- (void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer {
	[self.view.layer addSublayer:cameraLayer];
	if (_needShowDebugLocation) {
		[self.view addSubview:arView];
	}
	_arView = arView;
	[self.view bringSubviewToFront:self.backButton];
	[self.view bringSubviewToFront:self.radarImageView];
	[self.view bringSubviewToFront:self.tipImageView];
    [self.view bringSubviewToFront:self.promptView];
	[self.view bringSubviewToFront:self.helpButton];
//	[self.view bringSubviewToFront:self.helpView];
	dispatch_async(dispatch_get_main_queue(), ^{
	    //        [self.view bringSubviewToFront:self.mascotMotionView];
	    [self.view bringSubviewToFront:self.mascotImageView];
	    [self.view bringSubviewToFront:self.captureSuccessImageView];
	});
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    if (_type==NZLbsTypeDefault) {
        return;
    }
	BOOL needShowMascot = NO;
	// x坐标匹配
	if (fabs(arViewFrame.origin.x) >= SCREEN_WIDTH && fabs(arViewFrame.origin.x - arViewFrame.size.width) >= SCREEN_WIDTH) {
		needShowMascot = NO;
	}
	// y坐标匹配
	if (fabs(arViewFrame.origin.y) >= SCREEN_HEIGHT / 2) {
		needShowMascot = NO;
	}
	CGFloat distance = self.prARManager.arObject.distance.floatValue;
	if (distance > 500) {
		self.tipLabel.text = _question.hint;
		self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
		needShowMascot = NO;
        self.radarImageView.hidden = NO;
	} else if (distance > 200) {
		self.tipLabel.text = kTipCloseMascot;
		self.tipImageView.image = [UIImage imageNamed:@"img_ar_notification_bg_1"];
		needShowMascot = NO;
        self.radarImageView.hidden = NO;
	} else if (distance > 0) {
		self.tipLabel.text = kTipTapMascotToCapture;
		self.tipImageView.image = [UIImage imageNamed:@"img_ar_notification_bg_2"];
		needShowMascot = YES;
        self.radarImageView.hidden = _isHadReward==YES? NO:YES;
        if (!_isShowedPrompt && !_isHadReward) {
            [self showPromptView];
        }
	}
	if (_needShowDebugLocation) {
		self.tipLabel.text = [NSString stringWithFormat:@"距离目标 %.1fm", distance];
	}
	//    self.mascotMotionView.hidden = !needShowMascot;
	//    self.mascotMotionView.imageView.hidden = !needShowMascot;
    
    self.mascotImageView.hidden = _isHadReward==YES? YES:!needShowMascot;
    

	[[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:problemTitle
							message:problemDetails
						       delegate:nil
					      cancelButtonTitle:@"Ok"
					      otherButtonTitles:nil];
	[alert show];
}

@end
