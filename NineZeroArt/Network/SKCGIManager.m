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
	return [NSString stringWithFormat:@"%@/otime/api/login/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)profileBaseCGIKey {
	return [NSString stringWithFormat:@"%@/ArtUser/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)commonBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Common/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)shareBaseCGIKey {
	return [NSString stringWithFormat:@"%@/Share/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)scanningBaseCGIKey {
	return [NSString stringWithFormat:@"%@/ArtScanning/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

@end
