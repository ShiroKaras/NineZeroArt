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

//第三方登录
- (void)loginWithThirdPlatform:(SKLoginUser *)user callback:(SKResponseCallback)callback;

- (void)logoutCallback:(SKResponseCallback)callback;

- (SKLoginUser *)loginUser;

- (void)quitLogin;
@end
