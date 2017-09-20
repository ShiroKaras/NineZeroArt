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
#import "SKProfileService.h"
#import "SKCommonService.h"
#import <Qiniu/QiniuSDK.h>

@interface SKServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (SKLoginService *)loginService;

/** profileService, 负责个人主页相关业务 */
- (SKProfileService *)profileService;

/** commonService, 负责公共部分相关业务 */
- (SKCommonService *)commonService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

@end
