//
//  SKStrongHoldService.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/24.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"
#import "CommonDefine.h"

@class SKStronghold;
@class SKStrongholdItem;

typedef void (^SKQuestionStrongholdListCallback) (BOOL success, NSArray<SKStronghold*> *strongholdList);
typedef void (^SKQuestionStrongholdItemCallback) (BOOL success, SKStrongholdItem *strongholdItem);

@interface SKStrongHoldService : NSObject

- (void)getStrongholdListWithMascotID:(NSString *)mid location:(CLLocation*)location cityCode:(NSString*)cityCode callback:(SKQuestionStrongholdListCallback)callback;

- (void)getStrongholdInfoWithID:(NSString*)sid callback:(SKQuestionStrongholdItemCallback)callback;

- (void)getTaskListWithLocation:(CLLocation*)location callback:(SKQuestionStrongholdListCallback)callback;

- (void)addTaskWithID:(NSString *)taskID;

- (void)deleteTaskWithID:(NSString *)taskID;

//据点扫一扫
- (void)scanningWithStronghold:(SKStrongholdItem *)strongholdItem forLoacation:(CLLocation*)location callback:(SKResponseCallback)callback;
@end
