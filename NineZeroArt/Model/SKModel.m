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

@implementation SKNotification
@end

@implementation SKScanning
@end

@implementation SKStronghold
@end

@implementation SKStrongholdItem
@end

@implementation SKDanmakuItem
@end
