//
//  ServerConfiguration.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/17.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "ServerConfiguration.h"

@implementation ServerConfiguration

+ (instancetype)sharedInstance {
	static ServerConfiguration *_sharedLocalization;
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
		[self loadConfigWithFileName:@"ServerConfigs.plist"];
	}

	return self;
}

- (NSString *)appHost {
	static NSString *appHost;
	if (!appHost) {
		appHost = [self stringValueWithKey:@"APPHOST"];
	}
	return appHost;
}

@end
