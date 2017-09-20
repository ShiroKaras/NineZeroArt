//
//  SKServiceManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

#import "SKLoginService.h"
#import "SKCommonService.h"
#import "SKPhotoService.h"
#import <Qiniu/QiniuSDK.h>

@interface SKServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (SKLoginService *)loginService;

/** commonService, 负责公共部分相关业务 */
- (SKCommonService *)commonService;

- (SKPhotoService *)photoService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

@end
