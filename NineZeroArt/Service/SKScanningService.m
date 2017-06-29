//
//  SKScanningService.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKScanningService.h"

@implementation SKScanningService

- (AFSecurityPolicy *)customSecurityPolicy {
	// /先导入证书
	NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"90appbundle" ofType:@"cer"]; //证书的路径
	NSData *certData = [NSData dataWithContentsOfFile:cerPath];

	// AFSSLPinningModeCertificate 使用证书验证模式
	AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

	// allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
	// 如果是需要验证自建证书，需要设置为YES
	securityPolicy.allowInvalidCertificates = YES;

	//validatesDomainName 是否需要验证域名，默认为YES；
	//假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
	//置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
	//如置为NO，建议自己添加对应域名的校验逻辑。
	securityPolicy.validatesDomainName = NO;

	securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];

	return securityPolicy;
}

- (void)scanningBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager setSecurityPolicy:[self customSecurityPolicy]];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];

	NSTimeInterval time = [[NSDate date] timeIntervalSince1970]; // (NSTimeInterval) time = 1427189152.313643
	long long int currentTime = (long long int)time;	     //NSTimeInterval返回的是double类型
	NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
	[mDict setValue:[NSString stringWithFormat:@"%lld", currentTime] forKey:@"time"];
	[mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
	[mDict setValue:@"iOS" forKey:@"client"];
	[mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];

	NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"Param:%@", jsonString);

	NSDictionary *param = @{ @"data": [NSString encryptUseDES:jsonString key:nil] };

	[manager POST:[SKCGIManager scanningBaseCGIKey]
		parameters:param
		progress:nil
		success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
		    SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
		    callback(YES, package);
		}
		failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
		    DLog(@"%@", error);
		    callback(NO, nil);
		}];
}

- (void)getScanningWithCallBack:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getScanning"
	};

    [self scanningBaseRequestWithParam:param
                              callback:^(BOOL success, SKResponsePackage *response) {
                                  callback(success, response);
                              }];
}

- (void)getScanningRewardWithRewardId:(NSString *)rewardId callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getRewardDetail",
		@"reward_id": rewardId
	};

    [self scanningBaseRequestWithParam:param
                              callback:^(BOOL success, SKResponsePackage *response) {
                                  callback(success, response);
                              }];
}

- (void)getScanningRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getScanningRewardDetail",
		@"reward_id": rewardId,
		@"sid": sId
	};

	[self scanningBaseRequestWithParam:param
				    callback:^(BOOL success, SKResponsePackage *response) {
					callback(success, response);
				    }];
}

- (void)getScanningPuzzleRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getLastMontageReward",
		@"reward_id": rewardId,
		@"sid": sId
	};

	[self scanningBaseRequestWithParam:param
				    callback:^(BOOL success, SKResponsePackage *response) {
					callback(success, response);
				    }];
}

- (void)getScanningPuzzleWithMontageId:(NSString *)montageId sId:(NSString *)sId callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getMontageRewardDetail",
		@"reward_id": montageId,
		@"sid": sId,
		@"montage_id": montageId
	};

	[self scanningBaseRequestWithParam:param
				    callback:^(BOOL success, SKResponsePackage *response) {
					callback(success, response);
				    }];
}

- (void)getTimeSlotRewardDetailWithRewardID:(NSString*)rewardId callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method": @"getTimeSlotRewardDetail",
                            @"reward_id" : rewardId
                            };
    [self scanningBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];

}

//3.0.1
- (void)getLbsRewardDetailWithID:(NSString *)rewardId sid:(NSString *)sid callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method": @"getLbsRewardDetail",
                            @"reward_id" : rewardId,
                            @"sid" : sid
                            };
    [self scanningBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
//        SKReward *reward = [SKReward mj_objectWithKeyValues:response.data];
        callback(success, response);
    }];
}

- (void)sendScanningComment:(NSString *)comment imageID:(NSString *)imageID callback:(SKResponseCallback)callback {
    if (comment==nil) {
        return;
    }
    NSDictionary *param = @{
                            @"method": @"giveScanningComment",
                            @"user_comment" : comment,
                            @"lid" : imageID
                            };
    [self scanningBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)getScanningBarrageWithImageID:(NSString *)imageID callback:(SKDanmakuListCallback)callback {
    NSDictionary *param = @{
                            @"method": @"getScanningBarrage",
                            @"lid" : imageID
                            };
    [self scanningBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKDanmakuItem*>*danmakuList = [NSMutableArray array];
        for (int i = 0; i < [response.data[@"user_comment"] count]; i++) {
            SKDanmakuItem *danmakuItem = [SKDanmakuItem mj_objectWithKeyValues:response.data[@"user_comment"][i]];
            [danmakuList addObject:danmakuItem];
        }
        callback(success, danmakuList);
    }];
}

@end
