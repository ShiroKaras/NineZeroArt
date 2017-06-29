//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKProfileInfoCallback) (BOOL success, SKProfileInfo *response);
typedef void (^SKUserInfoCallback) (BOOL success, SKUserInfo *response);
typedef void (^SKGetBadgesCallback) (BOOL success, NSInteger exp, NSInteger coopTime ,NSArray<SKBadge *> *badges, NSArray<SKBadge*> *medals) ;
typedef void (^SKGetPiecesCallback) (BOOL success, NSArray<SKPiece *> *pieces) ;
typedef void (^SKGetTicketsCallback) (BOOL suceese, NSArray<SKTicket*> *tickets);
typedef void (^SKGetRankerListCallbakc) (BOOL success, NSArray<SKRanker*> *rankerList);
typedef void (^SKGetNotificationsCallback) (BOOL success, NSArray<SKNotification *> *notifications);
typedef void (^SKTopicListCallback) (BOOL success, NSArray<SKTopic*> *topicList);

@interface SKProfileService : NSObject

//获取个人信息
- (void)getUserInfoDetailCallback:(SKProfileInfoCallback)callback;

//获取礼券列表
- (void)getUserTicketsCallbackCallback:(SKGetTicketsCallback)callback;

//获取个人排名
- (void)getUserRankCallback:(SKResponseCallback)callback;

//获取个人通知列表
- (void)getUserNotificationCallback:(SKGetNotificationsCallback)callback;

//获取基本信息
- (void)getUserBaseInfoCallback:(SKUserInfoCallback)callback;

//获取第一季排名
- (void)getSeason1RankListCallback:(SKGetRankerListCallbakc)callback;

//获取第二季排名
- (void)getSeason2RankListCallback:(SKGetRankerListCallbakc)callback;

//推送开关
- (void)updateNotificationSwitch:(BOOL)isOn callback:(SKResponseCallback)callback;

//修改个人信息    0头像 1昵称
- (void)updateUserInfoWith:(SKUserInfo*)userInfo withType:(int)type callback:(SKResponseCallback)callback;

//用户反馈
- (void)feedbackWithContent:(NSString *)content contact:(NSString *)contact completion:(SKResponseCallback)callback;

//重新获取用户信息
- (void)updateUserInfoFromServer;

//获取勋章
- (void)getBadges:(SKGetBadgesCallback)callback;

//获取碎片
- (void)getPieces:(SKGetPiecesCallback)callback;

//成就
- (void)getUserAchievement:(SKGetBadgesCallback)callback;

//参与的话题
- (void)getJoinTopicListCallback:(SKTopicListCallback)callback;

@end
