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
HTINIT(SKResponsePackage)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{ @"code" : @"result.code",
                                      @"message" : @"result.message"
                                      };
    return propertyMapper;
}
@end

@implementation SKLoginUser
@end

@implementation SKUserInfo
@end
