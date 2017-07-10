//
//  HTWebController.m
//  NineZeroProject
//
//  Created by ShiroKaras on 16/4/5.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "HTWebController.h"
#import "HTUIHeader.h"

@interface HTWebController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HTWebController {
	float lastOffsetY;
}

- (instancetype)initWithURLString:(NSString *)urlString {
	if (self = [super init]) {
		_urlString = urlString;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = COMMON_BG_COLOR;
    if (_type==1) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    } else {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width - 20, self.view.bounds.size.height - 64)];
    }
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

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-49, self.view.width, 49)];
    bottomView.backgroundColor = COMMON_TITLE_BG_COLOR;
    [self.view addSubview:bottomView];
    
    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(@13.5);
    }];


	[HTProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
    if (_type==1) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    } else {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width - 20, self.view.bounds.size.height - 64)];
    }
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[HTProgressHUD dismiss];
	//    [self showTipsWithText:@"加载失败" offset:64];
	UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
	backView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:backView];

	HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
	blankView.center = self.view.center;
	[blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:11];
	[backView addSubview:blankView];
}

@end
