//
//  UIViewController+HTTips.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/19.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTUIHeader.h"

#import "UIViewController+HTTips.h"

@implementation UIViewController (HTTips)

- (void)showTipsWithText:(NSString *)text {
	[self showTipsWithText:text color:COMMON_PINK_COLOR];
}

- (void)showTipsWithText:(NSString *)text color:(UIColor *)color {
	if (text.length == 0)
		text = @"操作失败";
	UIView *tipsBackView = [[UIView alloc] init];
	tipsBackView.backgroundColor = color;
	[KEY_WINDOW addSubview:tipsBackView];

	UILabel *tipsLabel = [[UILabel alloc] init];
	tipsLabel.font = [UIFont systemFontOfSize:16];
	tipsLabel.textAlignment = NSTextAlignmentCenter;
	tipsLabel.textColor = [UIColor whiteColor];
	[tipsBackView addSubview:tipsLabel];

	[tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
	    if (self.navigationController == nil || self.navigationController.navigationBar.hidden == YES) {
		    make.top.equalTo(KEY_WINDOW).offset(0);
	    } else {
		    make.top.equalTo(KEY_WINDOW).offset(0);
	    }
	    make.width.equalTo(KEY_WINDOW);
	    make.height.equalTo(@42);
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

- (void)showTipsWithText:(NSString *)text offset:(NSInteger)offset {
	if (text.length == 0)
		text = @"操作失败";
	UIView *tipsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 42+offset)];
	tipsBackView.backgroundColor = COMMON_PINK_COLOR;
	[KEY_WINDOW addSubview:tipsBackView];

	UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offset, tipsBackView.width, 42)];
	tipsLabel.font = [UIFont systemFontOfSize:16];
	tipsLabel.textAlignment = NSTextAlignmentCenter;
	tipsLabel.textColor = [UIColor whiteColor];
	[tipsBackView addSubview:tipsLabel];
    
	tipsLabel.text = text;
	CGFloat tipsBottom = tipsBackView.bottom;
	tipsBackView.bottom = 0;
    
    tipsBackView.hidden = NO;
	[UIView animateWithDuration:0.3
		animations:^{
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
