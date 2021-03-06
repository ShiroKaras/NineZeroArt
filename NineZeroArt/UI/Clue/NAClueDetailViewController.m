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

@interface NAClueDetailViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlString;

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出图片
@property (nonatomic ,strong) AVCaptureStillImageOutput *imageOutput;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation NAClueDetailViewController

- (instancetype)initWithScanning:(SKScanning*)scanning urlString:(NSString*)urlString{
    self = [super init];
    if (self) {
        self.scanning = scanning;
        self.urlString = urlString;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:_webView];
    
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    cView.backgroundColor = COMMON_BG_COLOR;
    cView.alpha = 0.5;
    cView.layer.cornerRadius = 16;
    [self.view addSubview:cView];
    cView.top = 28;
    cView.left = 13.5;
    
    _nextButton = [UIButton new];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_cluedetailpage_experience_highlight"] forState:UIControlStateHighlighted];
    _nextButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_nextButton];
    
    [HTProgressHUD show];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] scanningService] getScanningDetailWithSid:self.scanning.sid callBack:^(BOOL success, SKScanning *scanning) {
        self.scanning = scanning;
        NSLog(@"%@", scanning.file_url);
    }];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

- (void)nextButtonClick:(UIButton *)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        
        SKSwipeViewController *controller =  [[SKSwipeViewController alloc] initWithScanning:self.scanning];
        [self.navigationController pushViewController:controller animated:NO];
    } else if (authStatus == AVAuthorizationStatusRestricted ||
               authStatus == AVAuthorizationStatusDenied) {
        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
        [alertView show];
    } else {
        SKSwipeViewController *controller =  [[SKSwipeViewController alloc] initWithScanning:self.scanning];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HTProgressHUD dismiss];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
    blankView.center = self.view.center;
    [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:11];
    [backView addSubview:blankView];
}

@end
