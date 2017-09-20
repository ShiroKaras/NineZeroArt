//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "MJExtension.h"
#import <Foundation/Foundation.h>

@interface SKResult : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@end

// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, copy) NSString *method;   // 方法名
@property (nonatomic, assign) SKResult *result; // 结果信息
@property (nonatomic, strong) id data;          // 返回数据
@end

//登录信息
@interface SKLoginUser : NSObject
@property (nonatomic, copy) NSString *open_id;     // 第三方平台ID
@property (nonatomic, copy) NSString *plant_id;    // 微信 1
@property (nonatomic, copy) NSString *user_id;
@end

//用户基本信息
@interface SKUserInfo : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *gold;
@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, assign) BOOL push_setting; // 推送开关
@end

//用户个人页信息
@interface SKProfileInfo : NSObject
@property (nonatomic, copy) NSString *user_gold;	     //金币数
@property (nonatomic, copy) NSString *achievement_num;	    //勋章数量
@property (nonatomic, copy) NSString *ticket_num;	    //礼券数
@property (nonatomic, copy) NSString *experience_rank;  //排名
@property (nonatomic, copy) NSString *coop_rank;        //狩猎排名
@property (nonatomic, copy) NSString *join_num;         //参与话题数量
@property (nonatomic, copy) NSString *user_gemstone;	//宝石
@property (nonatomic, assign) BOOL user_gold_head;      //是否有头像边框
@end
