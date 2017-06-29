//
//  SKServiceManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKServiceManager.h"

@implementation SKServiceManager {
    SKLoginService      *_loginService;
    SKProfileService    *_profileService;
    SKScanningService   *_scanningService;
    SKCommonService     *_commonService;
    SKStrongHoldService *_strongholdService;
    QNUploadManager     *_qiniuService;
}

+ (instancetype)sharedInstance {
    static SKServiceManager *serviceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[SKServiceManager alloc] init];
    });
    return serviceManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _loginService       = [[SKLoginService alloc] init];
        _profileService     = [[SKProfileService alloc] init];
        _scanningService    = [[SKScanningService alloc] init];
        _commonService      = [[SKCommonService alloc] init];
        _strongholdService  = [[SKStrongHoldService alloc] init];
        _qiniuService       = [[QNUploadManager alloc] init];
    }
    return self;
}

#pragma mark - Publice Method

- (SKLoginService *)loginService {
    return _loginService;
}

- (SKProfileService *)profileService {
    return _profileService;
}

- (SKScanningService *)scanningService {
    return _scanningService;
}

- (SKCommonService *)commonService {
    return _commonService;
}


- (SKStrongHoldService *)strongholdService {
    return _strongholdService;
}

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}
@end
