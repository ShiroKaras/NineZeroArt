//
//  ClientConfiguration.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/17.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "ClientConfiguration.h"

@implementation ClientConfiguration

+ (instancetype)sharedInstance {
	static ClientConfiguration *_sharedLocalization;
	static dispatch_once_t onceToken;

	if (!_sharedLocalization) {
		dispatch_once(&onceToken, ^{
		    _sharedLocalization = [[self alloc] init];
		});
	}

	return _sharedLocalization;
}

- (id)init {
	if ((self = [super init])) {
		[self loadConfigWithFileName:@"ClientConfigs.plist"];
	}

	return self;
}

- (NSString *)appStoreId {
	return [self stringValueWithKey:@"AppStoreID"];
}

- (NSString *)JPUSHServiceAppKey {
	return [self stringValueWithKey:@"JPUSHServiceAppKey"];
}

- (NSString *)AMapServicesAPIKey {
	return [self stringValueWithKey:@"AMapServicesAPIKey"];
}

- (NSString *)ShareSDKAppKey {
	return [self stringValueWithKey:@"ShareSDKAppKey"];
}

- (NSString *)SSDKPlatformTypeSinaWeiboAppKey {
	return [self stringValueWithKey:@"SSDKPlatformTypeSinaWeiboAppKey"];
}

- (NSString *)SSDKPlatformTypeSinaWeiboAppSecret {
	return [self stringValueWithKey:@"SSDKPlatformTypeSinaWeiboAppSecret"];
}

- (NSString *)SSDKPlatformTypeSinaWeiboRedirectUri {
	return [self stringValueWithKey:@"SSDKPlatformTypeSinaWeiboRedirectUri"];
}

- (NSString *)SSDKPlatformTypeWechatAppId {
	return [self stringValueWithKey:@"SSDKPlatformTypeWechatAppId"];
}

- (NSString *)SSDKPlatformTypeWechatAppSecret {
	return [self stringValueWithKey:@"SSDKPlatformTypeWechatAppSecret"];
}

- (NSString *)SSDKPlatformTypeQQAppId {
	return [self stringValueWithKey:@"SSDKPlatformTypeQQAppId"];
}

- (NSString *)SSDKPlatformTypeQQAppKey {
	return [self stringValueWithKey:@"SSDKPlatformTypeQQAppKey"];
}

- (NSString *)UMAnalyticsConfigAppKey {
	return [self stringValueWithKey:@"UMAnalyticsConfigAppKey"];
}

- (NSString *)JPUSHServiceChannel {
	return [self stringValueWithKey:@"JPUSHServiceChannel"];
}

- (NSString *)TalkingDataSession {
	return [self stringValueWithKey:@"TalkingDataSession"];
}

- (NSString *)EasyARAppKey {
	return [self stringValueWithKey:@"EasyARAppKey"];
}

@end
