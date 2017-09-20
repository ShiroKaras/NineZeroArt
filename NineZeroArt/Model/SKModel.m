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
