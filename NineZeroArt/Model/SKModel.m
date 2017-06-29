//
//  SKModel.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKModel.h"
#import "MJExtension.h"

#define HTINIT(T)                                                                \
	-(instancetype)init {                                                    \
		if (self = [super init]) {                                       \
			[T mj_setupReplacedKeyFromPropertyName:^NSDictionary * { \
			    return [self propertyMapper];                        \
			}];                                                      \
		}                                                                \
		return self;                                                     \
	}

@implementation SKResponsePackage
@end

@implementation SKLoginUser
@end

@implementation SKUserInfo
@end

@implementation SKProfileInfo
@end

@implementation SKIndexInfo

HTINIT(SKIndexInfo)
- (NSDictionary *)propertyMapper {
	NSDictionary *propertyMapper = @{ @"question_end_time": @"question_info.end_time",
                                      @"qid": @"question_info.qid",
                                      @"answered_status": @"question_info.answered_status",
                                      @"monday_end_time": @"Monday.end_time",
                                      @"adv_pic": @"advertising.adv_pic",
                    
	};
	return propertyMapper;
}

@end

@implementation SKIndexScanning

HTINIT(SKIndexScanning)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{
                                     @"pet_gif" : @"scanning_adv.pet_gif",
                                     @"reward_id" : @"scanning_adv.reward_id",
                                     @"scanning_type" : @"scanning_adv.scanning_type",
                                     @"is_haved_reward" : @"scanning_adv.is_haved_reward",
                                     @"adv_pic": @"advertising.adv_pic"
                                     };
    return propertyMapper;
}
@end

@implementation SKQuestion

HTINIT(SKQuestion)
- (NSDictionary *)propertyMapper {
	NSDictionary *propertyMapper = @{ @"description_url": @"description"
	};
	return propertyMapper;
}

@end

@implementation SKHintList
@end

@implementation SKAnswerDetail
@end

@implementation SKMascotProp
@end

@implementation SKTicket
@end

@implementation SKPiece
@end

@implementation SKPet
@end

@implementation SKPetCoop
@end

@implementation SKReward
@end

@implementation SKBadge
@end

@implementation SKRanker
@end

@implementation SKMascotEvidence
@end

@implementation SKMascot
-(instancetype)init {
    if (self = [super init]) {
        [SKMascot mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"crime_evidence" : @"SKMascotEvidence",
                     };
        }];
    }
    return self;
}
@end

@implementation SKDefaultMascotSkill
@end

@implementation SKDefaultMascotDetail
@end

@implementation SKNotification
@end

@implementation SKScanning
@end

@implementation SKChatObject
@end

@implementation SKStronghold
@end

@implementation SKStrongholdItem
@end

@implementation SKBanner
@end

@implementation SKTopic
@end

@implementation SKComment
@end

@implementation SKTopicDetailBase
@end

@implementation SKTopicDetail
-(instancetype)init {
    if (self = [super init]) {
        [SKTopicDetail mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"user_comment" : @"SKComment",
                     };
        }];
    }
    return self;
}
@end

@implementation SKDanmakuItem
@end
