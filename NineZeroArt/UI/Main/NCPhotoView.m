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

@interface NCPhotoView ()
@property (nonatomic, strong) UIImage *image;
@end

@implementation NCPhotoView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //模糊
    UIImageView *blurImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_printingpage_background_%lf", MIN(SCREEN_WIDTH, SCREEN_HEIGHT)]]];
    blurImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:blurImageView];
    
    UIImage *photoPaperImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_printingpage_frame_%lf", MIN(SCREEN_WIDTH, SCREEN_HEIGHT)]];
    
    UIView *photoPaperView = [UIView new];
    photoPaperView.size = photoPaperImage.size;
    photoPaperView.centerX = self.centerX;
    photoPaperView.bottom = 0;
    [self addSubview:photoPaperView];
    
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor colorWithHex:0xd8d8d8];
    grayView.size = CGSizeMake(335, 335);
    grayView.top = 20.5;
    grayView.centerX = photoPaperView.width/2;
    [photoPaperView addSubview:grayView];
    
    //剪裁
    float iw = self.image.size.width;
    float ih = self.image.size.height;
    UIImage *resizeImage = [[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect([self.image CGImage], CGRectMake(0,0, MIN(iw, ih), MIN(iw, ih))) scale:1 orientation:UIImageOrientationLeft];
    UIImageView *cropImageView = [[UIImageView alloc] initWithImage:resizeImage];
    cropImageView.size = CGSizeMake(335, 335);
    cropImageView.top = 20.5;
    cropImageView.centerX = photoPaperView.width/2;
    [photoPaperView addSubview:cropImageView];
    
    //相纸
    UIImageView *imageView = [[UIImageView alloc] initWithImage:photoPaperImage];
    [photoPaperView addSubview:imageView];
    imageView.top = 0;
    imageView.left = 0;
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = @"分享到";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(18);
    [textLabel sizeToFit];
    [self addSubview:textLabel];
    textLabel.bottom = self.bottom - 96;
    textLabel.centerX = self.centerX;
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor whiteColor];
    [self addSubview:line1];
    line1.size = CGSizeMake(ROUND_WIDTH_FLOAT(127), 1);
    line1.left = ROUND_WIDTH_FLOAT(22);
    line1.centerY = textLabel.centerY;
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor whiteColor];
    [self addSubview:line2];
    line2.size = CGSizeMake(ROUND_WIDTH_FLOAT(127), 1);
    line2.centerY = textLabel.centerY;
    line2.right = self.right-ROUND_WIDTH_FLOAT(22);
    
    NSArray *loginArray = @[@"wechat", @"moments", @"weibo", @"qq"];
    float padding = ROUND_WIDTH_FLOAT((SCREEN_WIDTH-30-63*4)/3);
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_printingpage_%@", loginArray[i]]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_printingpage_%@_highlight", loginArray[i]]] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(ROUND_WIDTH_FLOAT(63), ROUND_WIDTH_FLOAT(60));
        button.left = ROUND_WIDTH_FLOAT(17+(padding+63)*i);
        button.bottom = self.bottom - ROUND_WIDTH_FLOAT(17);
        [self addSubview:button];
    }
    
    //显示动画
    cropImageView.alpha = 0;
    [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        photoPaperView.bottom = self.bottom-126.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
            cropImageView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
