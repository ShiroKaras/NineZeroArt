//
//  DemoDanmakuItemData.h
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/2/13.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXDanmakuItemData.h"
#import <UIKit/UIKit.h>

@interface DemoDanmakuItemData : FXDanmakuItemData

@property (nonatomic, copy) NSString *avatarName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) UIColor *backColor;

+ (instancetype)data;
+ (instancetype)highPriorityData;

@end
