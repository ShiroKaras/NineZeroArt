//
//  SKPhotoService.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKPhotoService.h"
#import "SKModel.h"
#import "SKStorageManager.h"
#import "SKServiceManager.h"

@implementation SKPhotoService

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

- (void)photoBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
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
    DLog(@"Json ParamString: %@", jsonString);
    
    NSDictionary *param = @{ @"data": [NSString encryptUseDES:jsonString key:nil] };
//    NSDictionary *param = @{ @"data": jsonString };
    
    [manager POST:[SKCGIManager photoBaseCGIKey]
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

- (void)uploadPhotoWithURL:(NSString *)url Callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method": @"take_photo",
                            @"photo_addr": url
                            };
    
    [self photoBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        if (response.code == 0) {
            callback(YES, response);
        }
    }];
}

- (void)showPhotoCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method": @"show_photo"
                            };
    [self photoBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        if (response.code == 0) {
            callback(YES, response);
        } else {
            callback(NO, response);
        }
    }];
}

@end
