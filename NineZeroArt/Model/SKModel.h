//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "MJExtension.h"
#import <Foundation/Foundation.h>

// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, strong) id data;		// 返回数据
@property (nonatomic, strong) NSString *method; // 方法名
@property (nonatomic, assign) NSInteger result; // 结果code
@end

//登录信息
@interface SKLoginUser : NSObject
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_area_id; // 用户所在城市ID
@property (nonatomic, copy) NSString *code;	 // 验证码
@property (nonatomic, copy) NSString *third_id;     // 第三方平台ID
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

@interface SKAnswerDetail : NSObject
@property (nonatomic, copy) NSString *area_id;

@property (nonatomic, copy) NSString *pet_id;
@property (nonatomic, copy) NSString *qid;
@property (nonatomic, copy) NSString *article_title;
@property (nonatomic, copy) NSString *article_desc;
//@property (nonatomic, copy)     NSString    *article_subtitle;
@property (nonatomic, copy) NSString *article_pic;
@property (nonatomic, copy) NSString *article_pic_1;
@property (nonatomic, copy) NSString *article_video_url;

@property (nonatomic, copy) NSString *article_Illustration; //头图或视频
@property (nonatomic, copy) NSString *article_Illustration_url;
@property (nonatomic, copy) NSString *article_Illustration_cover; //头视频封面
@property (nonatomic, copy) NSString *article_Illustration_cover_url;
@property (nonatomic, assign) NSInteger article_Illustration_type; // 0:无  1:视频  2:图片

@end

@interface SKMascotProp : NSObject
@end

@interface SKTicket : NSObject
@property (nonatomic, copy) NSString *ticket_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) uint64_t create_time;
@property (nonatomic, assign) uint64_t expire_time;
@property (nonatomic, assign) uint64_t used_time;
@property (nonatomic, assign) BOOL used;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *ticket_cover;
@property (nonatomic, copy) NSString *remarks; //描述
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, copy) NSString *item_name;
@property (nonatomic, copy) NSString *item_type;
@property (nonatomic, copy) NSString *item_num;
@property (nonatomic, copy) NSString *extra_data;
@end

@interface SKPet : NSObject
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *pet_gif;

@property (nonatomic, assign) NSInteger pet_id;
@property (nonatomic, copy) NSString *pet_desc;
@property (nonatomic, copy) NSString *pet_name;
@property (nonatomic, copy) NSString *pet_family_num;
@property (nonatomic, assign) BOOL user_haved;

@property (nonatomic, assign) NSInteger pet_num;
@property (nonatomic, assign) NSInteger pet_pic;
@end

@interface SKPiece : NSObject
@property (nonatomic, copy) NSString *piece_name;
@property (nonatomic, copy) NSString *piece_describe_pic;
@property (nonatomic, copy) NSString *piece_cover_pic;
@property (nonatomic, copy) NSString *piece_describtion;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *expire_time;
@end

@interface SKPetCoop : NSObject
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *crime_pic;
@end

//用户奖励
@interface SKReward : NSObject
@property (nonatomic, copy) NSString *reward_id;
@property (nonatomic, copy) NSString *gold;
@property (nonatomic, copy) NSString *experience_value;
@property (nonatomic, copy) NSString *gemstone;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, strong) SKPet *pet;
@property (nonatomic, strong) SKPiece *piece;
@property (nonatomic, strong) SKTicket *ticket;
@property (nonatomic, strong) SKPetCoop *petCoop;
@end

@interface SKRanker : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *gold;
@property (nonatomic, assign) NSUInteger rank;
@property (nonatomic, copy) NSString *user_experience_value;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, assign) BOOL user_gold_head; //是否有头像边框
@property (nonatomic, copy) NSString *total_coop_time;  //关押时间
@end

@interface SKMascotEvidence : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *crime_name;
@property (nonatomic, copy) NSString *crime_pic;
@property (nonatomic, copy) NSString *crime_description;
@property (nonatomic, copy) NSString *crime_thumbnail_pic;
@end

@interface SKMascot : NSObject
@property (nonatomic, copy) NSString *pet_name;
@property (nonatomic, copy) NSString *pet_id;
@property (nonatomic, copy) NSString *last_coop_time;   //剩余时间
@property (nonatomic, copy) NSString *pet_archives;     //零仔档案头图
@property (nonatomic, copy) NSString *pet_desc;         //零仔描述
@property (nonatomic, strong) NSArray<SKMascotEvidence*> *crime_evidence;    //犯罪证据
@end

@interface SKNotification : NSObject
@property (nonatomic, assign) uint64_t notice_id; // 消息id
@property (nonatomic, assign) uint64_t user_id;   // 用户id
@property (nonatomic, assign) uint64_t time;      // 通知时间
@property (nonatomic, assign) uint64_t title;     // 通知标题
@property (nonatomic, strong) NSString *content;  // 内容
@end

//扫一扫
@interface SKScanning : NSObject
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_place;
@property (nonatomic, copy) NSString *list_pic;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *status; //状态（1：活动开启，0：活动关闭
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *reward_id;
@property (nonatomic, copy) NSString *file_url;         //压缩包文件名
@property (nonatomic, copy) NSString *file_url_true;    //压缩包URL
@property (nonatomic, copy) NSArray *link_url;
@property (nonatomic, assign) BOOL is_haved_ticket;
@property (nonatomic, copy) NSArray *lid;
@property (nonatomic, assign) BOOL bstatus;
@end

//据点
@interface SKStronghold : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *difficulty;   //难度
@property (nonatomic, copy) NSString *distance;     //距离
@property (nonatomic, copy) NSString *thumbnail;    //缩略图
@property (nonatomic, copy) NSString *name_pic;     //标题图片
@end

//据点内项目
@interface SKStrongholdItem : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cid;          //城市ID
@property (nonatomic, copy) NSString *pid;          //零仔ID
@property (nonatomic, copy) NSString *name_pic;     //目标名
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *thumbnail;        //缩略图
@property (nonatomic, copy) NSString *bigpic;           //大图
@property (nonatomic, copy) NSString *target_address;   //目标时间
@property (nonatomic, copy) NSString *target_time;      //目标时间
@property (nonatomic, copy) NSString *telephone;        //电话
@property (nonatomic, strong) NSArray *article_details; //详情内容
@property (nonatomic, copy) NSString *difficulty;       //难度
@property (nonatomic, assign) BOOL task_status;         //是否已收藏
@property (nonatomic, assign) BOOL is_haved_pet;
@property (nonatomic, copy) NSString *pet_gif;
@property (nonatomic, copy) NSString *pet_gif_url;
@property (nonatomic, copy) NSString *pet_gif_id;
@end

@interface SKDanmakuItem : NSObject
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *contents;
@property (nonatomic, copy) NSString *release_time;
@end
