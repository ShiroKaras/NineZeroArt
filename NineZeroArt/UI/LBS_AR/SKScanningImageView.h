//
//  SKScanningImageView.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/23.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScanningImageView;
@protocol SKScanningImageViewDelegate <NSObject>
@optional

- (void)scanningImageView:(SKScanningImageView *)imageView didTapGiftButton:(id)giftButton;

@end

@interface SKScanningImageView : UIView

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UIImageView *scanningGridLine;
@property (nonatomic, strong) UIImageView *giftBackImageView;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIImageView *giftMascotHand;

- (void)showScanningGridLine;

- (void)removeScanningGridLine;

- (void)setUpGiftView;

- (void)pushGift;

- (void)removeGiftView;

@end
