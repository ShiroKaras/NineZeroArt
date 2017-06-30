//
//  SKScanningRewardViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/13.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKReward;
@class SKScanningRewardViewController;

@protocol SKScanningRewardDelegate <NSObject>

- (void)didClickBackButtonInScanningCaptureController:(SKScanningRewardViewController *)controller;

@end

@interface SKScanningRewardViewController : UIViewController

@property (nonatomic, weak) id<SKScanningRewardDelegate> delegate;

- (instancetype)initWithRewardID:(NSString *)rewardID sId:(NSString *)sId scanType:(NSUInteger)scanType;

- (instancetype)initWithReward:(SKReward *)reward;
@end
