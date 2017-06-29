//
//  SKScanningService.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKLogicHeader.h"
#import "SKNetworkDefine.h"
#import <Foundation/Foundation.h>

@interface SKScanningService : NSObject

typedef void (^SKScanningCallback)(BOOL success, SKResponsePackage *package);
typedef void (^SKScanningRewardCallback)(BOOL success, SKReward *reward);
typedef void (^SKDanmakuListCallback)(BOOL success, NSArray<SKDanmakuItem*>* danmakuList);

- (void)getScanningWithCallBack:(SKResponseCallback)callback;

- (void)getScanningRewardWithRewardId:(NSString *)rewardId callback:(SKResponseCallback)callback;

- (void)getScanningRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback;

- (void)getScanningPuzzleRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback;

- (void)getScanningPuzzleWithMontageId:(NSString *)montageId sId:(NSString *)sId callback:(SKResponseCallback)callback;

//3.0 获取限时零仔
- (void)getTimeSlotRewardDetailWithRewardID:(NSString*)rewardId callback:(SKResponseCallback)callback;

//3.0.1
//获取 LBS 奖励接口
- (void)getLbsRewardDetailWithID:(NSString*)rewardId sid:(NSString*)sid callback:(SKResponseCallback)callback;

//图片识别弹幕评论接口
- (void)sendScanningComment:(NSString *)comment imageID:(NSString*)imageID callback:(SKResponseCallback)callback;

//图片识别弹幕详情接口
- (void)getScanningBarrageWithImageID:(NSString *)imageID callback:(SKDanmakuListCallback)callback;

@end
