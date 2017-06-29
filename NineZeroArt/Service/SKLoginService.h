//
//  SKLoginService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

@interface SKLoginService : NSObject

- (void)loginBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback;

//注册
- (void)registerWith:(SKLoginUser *)user callback:(SKResponseCallback)callback;

//登录
- (void)loginWith:(SKLoginUser *)user callback:(SKResponseCallback)callback;

//第三方登录
- (void)loginWithThirdPlatform:(SKLoginUser *)user callback:(SKResponseCallback)callback;

//重置密码
- (void)resetPassword:(SKLoginUser *)user callback:(SKResponseCallback)callback;

//发送验证码
- (void)sendVerifyCodeWithMobile:(NSString *)mobile callback:(SKResponseCallback)callback;

//验证手机是否注册
- (void)checkMobileRegisterStatus:(NSString *)mobile callback:(SKResponseCallback)callback;


- (SKLoginUser *)loginUser;

- (void)quitLogin;
@end
