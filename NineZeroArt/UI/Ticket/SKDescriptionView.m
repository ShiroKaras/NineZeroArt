//
//  SKDescriptionView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKDescriptionView.h"
#import "HTUIHeader.h"

@interface SKTicketDescriptionView : UIScrollView
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *deadLine;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UILabel *mobile;
@property (nonatomic, strong) UILabel *remarksLabel;    //备注
@property (nonatomic, strong) UILabel *codeTipLabel;   // “唯一兑换码”
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *careTipLabel;   // “注意事项”
@property (nonatomic, strong) UILabel *careTip1;
@property (nonatomic, strong) UILabel *careTip2;
@property (nonatomic, strong) UILabel *careTip3;
@property (nonatomic, strong) UIView *coverView;
- (void)setReward:(SKTicket *)reward;
@end

@implementation SKTicketDescriptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [self addSubview:_coverView];
        
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:19];
        _title.textColor = [UIColor colorWithHex:0xffffff];
        [_coverView addSubview:_title];
        
        _deadLine = [self commonStyleLabel];
        _location = [self commonStyleLabel];
        _location.numberOfLines = 0;
        _mobile = [self commonStyleLabel];
        _remarksLabel = [self commonStyleLabel];
        _remarksLabel.numberOfLines = 0;
        _codeTipLabel = [self commonStyleLabel];
        
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = MOON_FONT_OF_SIZE(30);
        _codeLabel.textColor = COMMON_PINK_COLOR;
        [_coverView addSubview:_codeLabel];
        
        _careTipLabel = [self commonStyleLabel];
        _careTip1 = [self commonStyleLabel];
        _careTip2 = [self commonStyleLabel];
        _careTip3 = [self commonStyleLabel];
        _careTip3.numberOfLines = 0;
        _careTip3.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return self;
}

- (void)setReward:(SKTicket *)reward {
    _title.text = reward.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:reward.expire_time];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    NSString *year = [confromTimespStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [confromTimespStr substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [confromTimespStr substringWithRange:NSMakeRange(6, 2)];
    _deadLine.text =  [NSString stringWithFormat:@"礼券有效期至%@-%@-%@", year, month, day];
    _location.text = [NSString stringWithFormat:@"地点：%@", reward.address];
    _mobile.text = [NSString stringWithFormat:@"电话：%@", reward.mobile];
    if (reward.remarks!=nil&&![reward.remarks isEqualToString:@""]) {
        _remarksLabel.text = [NSString stringWithFormat:@"备注：%@", reward.remarks];
    }
    _codeTipLabel.text = @"唯一兑换码";
    _codeLabel.text = [NSString stringWithFormat:@"%@", reward.code];
    _careTipLabel.text = @"注意事项：";
    _careTip1.text = @"1.本活动仅限本人；";
    _careTip2.text = @"2.如有疑问，请联系客服；";
    _careTip3.text = @"3.最终解释权归深圳九零九五网络科技公司所有；";
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftMargin = 23;
    CGFloat labelVerticalMargin = 11;
    _title.frame = CGRectMake(leftMargin, 18, self.width - 2 * leftMargin, 20);
    _deadLine.frame = CGRectMake(leftMargin, _title.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    [_location sizeToFit];
    _location.frame = CGRectMake(leftMargin, _deadLine.bottom + labelVerticalMargin, self.width - 2 * leftMargin, _location.height);
    _mobile.frame = CGRectMake(leftMargin, _location.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    if (_remarksLabel.text!=nil&&![_remarksLabel.text isEqualToString:@""]) {
        [_remarksLabel sizeToFit];
        _remarksLabel.frame = CGRectMake(leftMargin, _mobile.bottom + labelVerticalMargin, self.width - 2 * leftMargin, _remarksLabel.height);
        _codeTipLabel.frame = CGRectMake(leftMargin, _remarksLabel.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    } else {
        _codeTipLabel.frame = CGRectMake(leftMargin, _mobile.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    }
    _codeLabel.frame = CGRectMake(leftMargin, _codeTipLabel.bottom + 9, self.width - 2 * leftMargin, 30);
    _careTipLabel.frame = CGRectMake(leftMargin, _codeLabel.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _careTip1.frame = CGRectMake(leftMargin, _careTipLabel.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _careTip2.frame = CGRectMake(leftMargin, _careTip1.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    [_careTip3 sizeToFit];
    _careTip3.frame = CGRectMake(leftMargin, _careTip2.bottom + labelVerticalMargin, self.width - 2 * leftMargin, _careTip3.height);
    self.contentSize = CGSizeMake(self.width, _careTip3.bottom + labelVerticalMargin);
    _coverView.frame = CGRectMake(0, 0, self.width, self.contentSize.height);
}

- (UILabel *)commonStyleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHex:0xd9d9d9];
    [_coverView addSubview:label];
    return label;
}

@end

@interface SKDescriptionView () <UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *converView;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, assign, readwrite) SKDescriptionType type;
@property (nonatomic, strong) SKTicketDescriptionView *rewardDescriptionView;
@end

@implementation SKDescriptionView

- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type {
    if (self = [super initWithFrame:CGRectZero]) {
        _type = type;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.alpha = 0.8;
        //        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        [_backView addGestureRecognizer:tap];
        [self addSubview:_backView];
        
        _converView = [[UIView alloc] init];
        _converView.backgroundColor = COMMON_SEPARATOR_COLOR;
        [_backView addSubview:_converView];
        
        
        UIImage *coverImage = (type == SKDescriptionTypeProp) ? [UIImage imageNamed:@"props_cover"] : [UIImage imageNamed:@"img_profile_archive_cover_default"];
        _imageView = [[UIImageView alloc] initWithImage:coverImage];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor blackColor];
        [_converView addSubview:_imageView];
        
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeButton.layer.cornerRadius = 5.0f;
        _exchangeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_exchangeButton addTarget:self action:@selector(didClickExchangedButton) forControlEvents:UIControlEventTouchUpInside];
        [_converView addSubview:_exchangeButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_popover_close"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_popover_close_highlight"] forState:UIControlStateHighlighted];
        [_cancelButton sizeToFit];
        [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [_backView addSubview:_cancelButton];
        
        if (type == SKDescriptionTypeReward) {
            _rewardDescriptionView = [[SKTicketDescriptionView alloc] initWithFrame:CGRectZero];
            [_rewardDescriptionView setReward:[[SKTicket alloc] init]];
            [_converView addSubview:_rewardDescriptionView];
        } else {
            _webView = [[UIWebView alloc] init];
            _webView.delegate = self;
            _webView.opaque = NO;
            _webView.backgroundColor = [UIColor clearColor];
            _webView.scrollView.backgroundColor = [UIColor clearColor];
            NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\"><div style=\"word-wrap:break-word; width:240px;\">%@</div></span></body></html>", urlString];
            [_webView loadHTMLString:htmlString baseURL: nil];
            _webView.delegate = self;
            NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
            [_webView stringByEvaluatingJavaScriptFromString:padding];
            _webView.alpha = 0;
            [_converView addSubview:_webView];
        }
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString {
    return [self initWithURLString:urlString andType:SKDescriptionTypeQuestion];
}

- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type andImageUrl:(NSString *)imageUrlString {
    self  = [self initWithURLString:urlString andType:type];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
    return self;
}

- (void)didClickCancelButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _backView.top = _backView.height;
        _dimmingView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didClickExchangedButton {
//    _changeView = [[HTPropChangedPopController alloc] initWithProp:_prop];
//    _changeView.delegate = self;
//    [_changeView show];
}

- (void)showAnimated {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIView *parentView = [self superview];
    self.frame = parentView.bounds;
    self.alpha = 0;
    self.top = parentView.top;
    _dimmingView.top = 0;
    _backView.top = parentView.bottom;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dimmingView.alpha = 0.8;
        _backView.top = 0;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setReward:(SKTicket *)reward {
    [_rewardDescriptionView setReward:reward];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:reward.pic] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
}

- (void)setBadge:(SKBadge *)badge {
    [_webView loadHTMLString:[self htmlStringWithContent:badge.medal_description] baseURL:nil];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:badge.medal_pic] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 280;
    CGFloat imageHeight = 240;
    CGFloat webViewHeight = 140;
    _backView.frame = self.bounds;
    _dimmingView.frame = self.bounds;
    _converView.frame = CGRectMake(self.width / 2 - width / 2, (80.0 / 568.0) * SCREEN_HEIGHT, width, imageHeight + webViewHeight);
    if (SCREEN_WIDTH > IPHONE5_SCREEN_WIDTH) {
        _converView.centerY = _backView.centerY - 20;
    }
    _converView.layer.cornerRadius = 5.0f;
    _converView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(0, 0, width, imageHeight);
    _imageView.layer.masksToBounds = YES;
    _exchangeButton.frame = CGRectMake(0, 0, 63, 33);
    _exchangeButton.right = _converView.width - 16;
    _exchangeButton.bottom = imageHeight - 15;
    if (_type == SKDescriptionTypeProp) {
        _webView.frame = CGRectMake(_imageView.left, imageHeight, width, webViewHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (_type == SKDescriptionTypeReward) {
        self.rewardDescriptionView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
        _rewardDescriptionView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    } else {
        _webView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    }
    _cancelButton.centerX = self.centerX;
    _cancelButton.top = _converView.bottom + 12;
}

- (NSString *)htmlStringWithContent:(NSString *)content {
    NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\">%@</span></body></html>", content];
    return htmlString;
}

#pragma mark - UIWebView Delegate 

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
    [_webView stringByEvaluatingJavaScriptFromString:padding];
}

@end
