//
//  ClientConfiguration.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/17.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "BaseConfiguration.h"

@interface ClientConfiguration : BaseConfiguration

- (NSString *)appStoreId;

- (NSString *)JPUSHServiceAppKey;

- (NSString *)AMapServicesAPIKey;

- (NSString *)ShareSDKAppKey;

- (NSString *)SSDKPlatformTypeSinaWeiboAppKey;

- (NSString *)SSDKPlatformTypeSinaWeiboAppSecret;

- (NSString *)SSDKPlatformTypeSinaWeiboRedirectUri;

- (NSString *)SSDKPlatformTypeWechatAppId;

- (NSString *)SSDKPlatformTypeWechatAppSecret;

- (NSString *)SSDKPlatformTypeQQAppId;

- (NSString *)SSDKPlatformTypeQQAppKey;

- (NSString *)UMAnalyticsConfigAppKey;

- (NSString *)JPUSHServiceChannel;

- (NSString *)TalkingDataSession;

- (NSString *)EasyARAppKey;

@end
