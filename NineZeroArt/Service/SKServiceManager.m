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
    SKCommonService     *_commonService;
    SKPhotoService      *_photoService;
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
        _commonService      = [[SKCommonService alloc] init];
        _photoService       = [[SKPhotoService alloc] init];
        _qiniuService       = [[QNUploadManager alloc] init];
    }
    return self;
}

#pragma mark - Publice Method

- (SKLoginService *)loginService {
    return _loginService;
}

- (SKCommonService *)commonService {
    return _commonService;
}

- (SKPhotoService *)photoService {
    return _photoService;
}

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}
@end
