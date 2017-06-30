//
//  SKScanningPuzzleView.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScanningPuzzleView;
@protocol SKScanningPuzzleViewDelegate <NSObject>
@optional

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapBoxButton:(UIButton *)button;
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapExchangeButton:(UIButton *)button;
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view isShowPuzzles:(BOOL)isShowPuzzles;

@end

@interface SKScanningPuzzleView : UIView

@property (nonatomic, weak) id delegate;

- (instancetype)initWithLinkClarity:(NSArray *)clarity rewardAction:(NSArray *)rewardAction defaultPic:(NSString *)defaultPic;

// 扫描线动画
- (void)showAnimationView;
- (void)hideAnimationView;

// 拼图扫一扫大包箱
- (void)showBoxView;
- (void)hideBoxView;

// 已获得碎片视图
- (void)setupPuzzleView;

// 底部扫一扫按钮
- (void)showPuzzleButton;
- (void)hidePuzzleButton;

@end
