//
//  SKDownloadProgressView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKDownloadProgressView.h"
#import "HTUIHeader.h"

@interface SKDownloadProgressView ()
@property (nonatomic, strong) UIView *progressView;
@end

@implementation SKDownloadProgressView

- (instancetype)init {
	self = [super init];
	if (self) {
		self.frame = CGRectMake(0, 0, 256, 43);

		UIView *progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 256, 10)];
		progressBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
		progressBackView.layer.cornerRadius = 5;
		progressBackView.layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
		progressBackView.layer.shadowOffset = CGSizeMake(1, 2);		   //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3)
		progressBackView.layer.shadowOpacity = 0.8;			   //阴影透明度，默认0
		progressBackView.layer.shadowRadius = 5;			   //阴影半径，默认
		[self addSubview:progressBackView];

		_progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 0, 10)];
		_progressView.backgroundColor = COMMON_GREEN_COLOR;
		_progressView.layer.cornerRadius = 5;
		[self addSubview:_progressView];

		UIImageView *mascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loadingvideo_text"]];
		mascotImageView.top = 0;
		mascotImageView.left = 155;
		[self addSubview:mascotImageView];
	}
	return self;
}

- (void)setProgressViewPercent:(float)percent {
	_progressView.width = 256 * percent;
}

@end
