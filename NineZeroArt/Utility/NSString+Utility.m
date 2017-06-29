//
//  NSString+Utility.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/17.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "SKModel.h"
#import "SKServiceManager.h"
#import "SKStorageManager.h"

#import "NSString+DES.h"
#define KEY @"keCzt$IAs"

@implementation NSString (Utility)

+ (NSString *)md5HexDigest:(NSString *)input {
	const char *str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];

	CC_MD5(str, (CC_LONG)strlen(str), result);

	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", result[i]];
	}
	return ret;
}

- (NSString *)md5 {
	const char *str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];

	CC_MD5(str, (CC_LONG)strlen(str), result);

	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", result[i]];
	}
	return ret;
}

+ (NSString *)sha256HashFor:(NSString *)input {
	const char *str = [input UTF8String];
	unsigned char result[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256(str, (CC_LONG)strlen(str), result);

	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", result[i]];
	}
	return ret;
}

- (NSString *)sha256 {
	return [NSString sha256HashFor:self];
}

+ (NSString *)confusedString:(NSString *)string withSalt:(NSString *)salt {
	return [NSString stringWithFormat:@"%01$@%02$@%01$@%02$@%01$@%02$@", string, salt];
}

- (NSString *)confusedWithSalt:(NSString *)salt {
	return [NSString stringWithFormat:@"%01$@%02$@%01$@%02$@%01$@%02$@", self, salt];
}

+ (NSString *)confusedPasswordWithLoginUser:(SKLoginUser *)loginUser {
	return [[NSString stringWithFormat:@"%01$@%02$@%02$@%02$@", loginUser.user_password, loginUser.user_mobile] sha256];
}

#pragma mark - 参数加密

- (NSString *)encParamWithJsonString:(NSString *)jsonString {
	NSString *desString = [NSString encryptUseDES:jsonString key:KEY];
	return desString;
}

#pragma mark - HmacSHA1加密；
+ (NSString *)hmacSha1:(NSString *)key data:(NSString *)data {
	const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
	//Sha256:
	// unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
	//CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

	//sha1
	unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

	NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
					      length:sizeof(cHMAC)];

	NSString *hash = [HMAC base64EncodedStringWithOptions:0]; //将加密结果进行一次BASE64编码。
	return hash;
}

- (NSString *)urlencode {
	NSMutableString *output = [NSMutableString string];
	const unsigned char *source = (const unsigned char *)[self UTF8String];
	unsigned long sourceLen = strlen((const char *)source);
	for (int i = 0; i < sourceLen; ++i) {
		const unsigned char thisChar = source[i];
		if (thisChar == ' ') {
			[output appendString:@"+"];
		} else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
			   (thisChar >= 'a' && thisChar <= 'z') ||
			   (thisChar >= 'A' && thisChar <= 'Z') ||
			   (thisChar >= '0' && thisChar <= '9')) {
			[output appendFormat:@"%c", thisChar];
		} else {
			[output appendFormat:@"%%%02X", thisChar];
		}
	}
	return output;
}

+ (NSString *)qiniuDownloadURLWithFileName:(NSString *)fileName {
	NSString *downloadURL = [NSString stringWithFormat:@"http://7xryb0.com1.z0.glb.clouddn.com/%@", [fileName urlencode]];
	return downloadURL;
}

+ (NSString *)avatarName {
	return [NSString stringWithFormat:@"avatar_%ld_%@", (time_t)[[NSDate date] timeIntervalSince1970], [[SKStorageManager sharedInstance] getUserID]];
}

- (NSDictionary *)dictionaryWithJsonString {
	NSError *jsonError;
	NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:objectData
								 options:NSJSONReadingMutableContainers
								   error:&jsonError];
	return jsonDict;
}

@end
