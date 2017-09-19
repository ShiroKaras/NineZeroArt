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
@property (nonatomic, strong) UIImage *photoPaperImage;
@property (nonatomic, strong) UIView *photoPaperView;
@property (nonatomic, strong) UIImageView *cropImageView;
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
    float iw = self.image.size.width;
    float ih = self.image.size.height;
    UIImage *resizeImage = [[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect([self.image CGImage], CGRectMake(0,0, MIN(iw, ih), MIN(iw, ih))) scale:1 orientation:UIImageOrientationLeft];
    self.cropImageView = [[UIImageView alloc] initWithImage:resizeImage];
    self.cropImageView.size = CGSizeMake(335, 335);
    self.cropImageView.top = 20.5;
    self.cropImageView.centerX = self.photoPaperView.width/2;
    [self.photoPaperView addSubview:self.cropImageView];
    
    //相纸
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.photoPaperImage];
    [self.photoPaperView addSubview:imageView];
    imageView.top = 0;
    imageView.left = 0;
    
    UIImageView *shareTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_printingpage_share"]];
    [self addSubview:shareTitleImageView];
    shareTitleImageView.centerX = self.centerX;
    shareTitleImageView.bottom = self.bottom -ROUND_HEIGHT_FLOAT(96);
    
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
    self.cropImageView.alpha = 0;
    [UIView animateWithDuration:1.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.photoPaperView.bottom = self.bottom-126.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPhoto {
    [UIView animateWithDuration:2 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.cropImageView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
