//
//  SKStrongHoldService.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/24.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKStrongHoldService.h"
#import "SKServiceManager.h"

@implementation SKStrongHoldService

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

- (void)strongholdBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
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
    
    [manager POST:[SKCGIManager strongHoldBaseCGIKey]
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

- (void)getStrongholdListWithMascotID:(NSString *)mid location:(CLLocation*)location cityCode:(NSString*)cityCode callback:(SKQuestionStrongholdListCallback)callback{
    NSDictionary *param = @{
                            @"method"   : @"getStrongholdList",
                            @"pid"      : mid,
                            @"city_code": cityCode,
                            @"lat"      : [NSString stringWithFormat:@"%lf", location.coordinate.latitude],
                            @"lng"      : [NSString stringWithFormat:@"%lf", location.coordinate.longitude]
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i < [response.data count]; i++) {
            SKStronghold *stronghold = [SKStronghold mj_objectWithKeyValues:response.data[i]];
            [dataArray addObject:stronghold];
        }
        callback(success, dataArray);
    }];
}

- (void)getStrongholdInfoWithID:(NSString *)sid callback:(SKQuestionStrongholdItemCallback)callback {
    NSDictionary *param = @{
                            @"method"   : @"strongholdInfo",
                            @"id"      : sid,
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        if (success) {
            SKStrongholdItem *strongholdItem = [SKStrongholdItem mj_objectWithKeyValues:response.data];
            NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
            if (strongholdItem.pet_gif) {
                [downloadKeys addObject:strongholdItem.pet_gif];
                [[[SKServiceManager sharedInstance] commonService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, SKResponsePackage *response) {
                    if (success) {
                        if (strongholdItem.pet_gif)
                            strongholdItem.pet_gif_url = response.data[strongholdItem.pet_gif];
                        callback(success, strongholdItem);
                    } else {
                        callback(false, strongholdItem);
                    }
                }];
            } else
                callback (success, strongholdItem);
            
        }
    }];
}

- (void)getTaskListWithLocation:(CLLocation*)location callback:(SKQuestionStrongholdListCallback)callback{
    NSDictionary *param = @{
                            @"method"   : @"getTaskList",
                            @"lat"      : [NSString stringWithFormat:@"%lf", location.coordinate.latitude],
                            @"lng"      : [NSString stringWithFormat:@"%lf", location.coordinate.longitude]
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i < [response.data count]; i++) {
            SKStronghold *stronghold = [SKStronghold mj_objectWithKeyValues:response.data[i]];
            [dataArray addObject:stronghold];
        }
        callback(success, dataArray);
    }];
}

- (void)addTaskWithID:(NSString *)taskID {
    NSDictionary *param = @{
                            @"method"   : @"addTask",
                            @"sid"      : taskID
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        
    }];
}

- (void)deleteTaskWithID:(NSString *)taskID {
    NSDictionary *param = @{
                            @"method"   : @"cancelTask",
                            @"sid"      : taskID
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        
    }];
}

- (void)scanningWithStronghold:(SKStrongholdItem *)strongholdItem forLoacation:(CLLocation*)location callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   : @"strongholdAnswer",
                            @"sid"      : strongholdItem.id,
                            @"lat"      : [NSString stringWithFormat:@"%lf", location.coordinate.latitude],
                            @"lng"      : [NSString stringWithFormat:@"%lf", location.coordinate.longitude],
                            @"pet_gif_id" : strongholdItem.pet_gif_id
                            };
    [self strongholdBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
