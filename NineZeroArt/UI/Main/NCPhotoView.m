//
//  NCPhotoView.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NCPhotoView.h"
#import "HTUIHeader.h"
#import "UIImage+FW.h"
#import "FWApplyFilter.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeWechat = 100,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ
};



@interface NCPhotoView ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *photoPaperImage;
@property (nonatomic, strong) UIView *photoPaperView;
@property (nonatomic, strong) UIImageView *cropImageView;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImageView *shareTitleImageView;
@property (nonatomic, strong) UIImageView *guideImageView;
@end

@implementation NCPhotoView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image imageURL:(NSString *)imageURL time:(NSString *)time {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        self.imageURL = imageURL;
        self.time = time;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //模糊
    UIImageView *blurImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_printingpage_background_%lf", MIN(SCREEN_WIDTH, SCREEN_HEIGHT)]]];
    blurImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:blurImageView];
    
    //相纸
    self.photoPaperImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_printingpage_frame_%lf", MIN(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    
    self.photoPaperView = [UIView new];
    self.photoPaperView.size = self.photoPaperImage.size;
    self.photoPaperView.centerX = self.centerX;
    self.photoPaperView.bottom = 0;
    [self addSubview:self.photoPaperView];
    
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor colorWithHex:0xd8d8d8];
    grayView.size = CGSizeMake(335, 335);
    grayView.top = 20.5;
    grayView.centerX = self.photoPaperView.width/2;
    [self.photoPaperView addSubview:grayView];
    
    //剪裁
    if (self.image) {
        float iw = self.image.size.width;
        float ih = self.image.size.height;
        UIImage *resizeImage = [[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect([self.image CGImage], CGRectMake(0,0, MIN(iw, ih), MIN(iw, ih))) scale:1 orientation:UIImageOrientationLeft];
        self.cropImageView = [[UIImageView alloc] initWithImage:resizeImage];
    } else {
        self.cropImageView = [UIImageView new];
        NSLog(@"%@", self.imageURL);
        [self.cropImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
    }
    self.cropImageView.size = CGSizeMake(335, 335);
    self.cropImageView.top = 20.5;
    self.cropImageView.centerX = self.photoPaperView.width/2;
    [self.photoPaperView addSubview:self.cropImageView];
    
    //相纸
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.photoPaperImage];
    [self.photoPaperView addSubview:imageView];
    imageView.top = 0;
    imageView.left = 0;
    
    //时间戳
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = [self timeWithTimeIntervalString:self.time];
    timeLabel.textColor = [UIColor colorWithHex:0x6d6d52];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        timeLabel.font = PINGFANG_FONT_OF_SIZE(14);
    } else {
        timeLabel.font = PINGFANG_FONT_OF_SIZE(16);
    }
    [timeLabel sizeToFit];
    [self.photoPaperView addSubview:timeLabel];
    timeLabel.bottom = self.photoPaperView.height - 78;
    timeLabel.right = self.photoPaperView.width - 22;
    
    self.guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_printingpage_floating"]];
    _guideImageView.alpha = 0;
    [self addSubview:_guideImageView];
    _guideImageView.centerX = self.centerX;
    _guideImageView.bottom = self.bottom - ROUND_HEIGHT_FLOAT(47);
    
    //分享
    self.shareTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_printingpage_share"]];
    self.shareTitleImageView.alpha = 0;
    [self addSubview:self.shareTitleImageView];
    self.shareTitleImageView.centerX = self.centerX;
    self.shareTitleImageView.bottom = self.bottom -ROUND_HEIGHT_FLOAT(96);
    
    NSArray *loginArray = @[@"wechat", @"moments", @"weibo", @"qq"];
    float padding = ROUND_WIDTH_FLOAT((SCREEN_WIDTH-30-63*4)/3);
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton new];
        button.alpha = 0;
        button.tag = 100+i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_printingpage_%@", loginArray[i]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_printingpage_%@_highlight", loginArray[i]]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
        button.size = CGSizeMake(ROUND_WIDTH_FLOAT(63), ROUND_WIDTH_FLOAT(60));
        button.left = ROUND_WIDTH_FLOAT(17+(padding+63)*i);
        button.bottom = self.bottom - ROUND_WIDTH_FLOAT(17);
        [self addSubview:button];
    }
    
    //显示动画
    self.cropImageView.alpha = 0;
    [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.photoPaperView.bottom = self.bottom-126.5;
        _guideImageView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [[[SKServiceManager sharedInstance] photoService] showPhotoCallback:^(BOOL success, SKResponsePackage *response) {
        self.imageURL = response.data[@"url_addr"];
        
    }];
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)showPhoto {
    [UIView animateWithDuration:2 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.cropImageView.alpha = 1;
        self.shareTitleImageView.alpha = 1;
        [self viewWithTag:100].alpha = 1;
        [self viewWithTag:101].alpha = 1;
        [self viewWithTag:102].alpha = 1;
        [self viewWithTag:103].alpha = 1;
        self.guideImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.guideImageView removeFromSuperview];
    }];
}

- (void)shareWithThirdPlatform:(UIButton *)sender {
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeWechat: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            NSArray *imageArray = @[self.imageURL];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"于是，我拍了这个……"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL([[SKStorageManager sharedInstance] getUserID])]
                                                  title:@"这只相机一生只能拍一张"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     DLog(@"State -> %lu", (unsigned long)state);
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeMoment: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.imageURL];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@""
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL([[SKStorageManager sharedInstance] getUserID])]
                                                  title:@"这只相机一生只能拍一张，于是，我拍了这个……"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeWeibo: {
            if (![WeiboSDK isWeiboAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.imageURL];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"这只相机一生只能拍一张，于是，我拍了这个…… %@", SHARE_URL([[SKStorageManager sharedInstance] getUserID])]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL([[SKStorageManager sharedInstance] getUserID])]
                                                  title:@"title"
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeQQ: {
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.imageURL];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"于是，我拍了这个……"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL([[SKStorageManager sharedInstance] getUserID])]
                                                  title:@"这只相机一生只能拍一张"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        default:
            break;
    }
}

@end
