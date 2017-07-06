//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

@implementation SKCGIManager

+ (NSString *)loginBaseCGIKey {
	return [NSString stringWithFormat:@"%@/ArtLogin/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)questionBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Question/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)profileBaseCGIKey {
	return [NSString stringWithFormat:@"%@/User/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)propBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Prop/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)mascotBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Pet/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)answerBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Answer/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)commonBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Common/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)shareBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Share/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)scanningBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Scanning/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)secretaryBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Secretary/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)strongHoldBaseCGIKey {
    return [NSString stringWithFormat:@"%@/Stronghold/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)topicBaseCGIKey {
    return [NSString stringWithFormat:@"%@/Topic/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

@end
