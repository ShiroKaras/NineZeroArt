//
//  BaseConfiguration.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/17.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "BaseConfiguration.h"
#import "NSDate+Utility.h"

@implementation BaseConfiguration

+ (instancetype)sharedInstance {
	NSAssert(NO, @"override me!");
	return nil;
}

+ (NSString *)funny {
	return [NSString stringWithFormat:@"%@(%@%@,*", @"X6", @"rhw", @"998"];
}

+ (NSDictionary *)decryptConfigWithFilePath:(NSString *)filePath {
	NSData *encryptData = [NSData dataWithContentsOfFile:filePath];
	NSData *decryptData = [encryptData AES256DecryptWithKey:[BaseConfiguration funny]];
	if (decryptData == nil) {
		NSLog(@"decrypt file %@ error!!!", filePath);
		return @{};
	}

	NSDictionary *config = nil;
	NSString *fileExtension = [filePath pathExtension];
	if ([fileExtension isEqualToString:@"json"]) {
		NSError *error = nil;
		config = [NSJSONSerialization JSONObjectWithData:decryptData options:0 error:&error];
	} else {
		CFPropertyListFormat fmt;
		CFErrorRef err;
		CFPropertyListRef plist = CFPropertyListCreateWithData(kCFAllocatorSystemDefault, (__bridge CFDataRef)decryptData, 0, &fmt, &err);
		// plist等同于NSDictionary
		if (plist != nil) {
			config = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)plist];
			CFRelease(plist);
		} else {
			config = @{};
		}
	}

	return config;
}

+ (BOOL)encryptConfig:(NSDictionary *)config toFilePath:(NSString *)filePath {
	NSData *data = [NSPropertyListSerialization dataWithPropertyList:config format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
	if (data == nil) {
		return false;
	}

	NSData *encryptData = [data AES256EncryptWithKey:[BaseConfiguration funny]];
	return [encryptData writeToFile:filePath atomically:YES];
}

- (void)loadConfigWithFileName:(NSString *)filename {
	if (filename.length <= 0 || filename == nil) {
		return;
	}

	NSString *filePath = [[NSBundle mainBundle] URLForResource:filename withExtension:nil].relativePath;

	_configs = [BaseConfiguration decryptConfigWithFilePath:filePath];
}

- (id)idValueWithKey:(NSString *)key {
	if (_configs == nil) {
		return nil;
	}
	id ret = [_configs objectForKey:key];

	if (ret == nil) {
		return nil;
	} else {
		return ret;
	}
}

- (BOOL)boolValueWithKey:(NSString *)key {
	return [[self idValueWithKey:key] boolValue];
}

- (int)intValueWithKey:(NSString *)key {
	return [[self idValueWithKey:key] intValue];
}

- (float)floatValueWithKey:(NSString *)key {
	return [[self idValueWithKey:key] floatValue];
}

- (NSString *)stringValueWithKey:(NSString *)key {
	return [self idValueWithKey:key];
}

- (NSDictionary *)dictionaryValueWithKey:(NSString *)key {
	return (NSDictionary *)[self idValueWithKey:key];
}

- (NSArray *)arrayValueWithKey:(NSString *)key {
	return (NSArray *)[self idValueWithKey:key];
}

@end
