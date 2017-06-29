//
//  SKNetworkDefine.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#ifndef SKNetworkDefine_h
#define SKNetworkDefine_h

#import "CustomSecurityPolicy.h"
#import "NSString+DES.h"
#import "SKModel.h"

// 公用
typedef void (^HTHTTPErrorCallback)(NSString *errorMessage);
typedef void (^HTHTTPSuccessCallback)(id responseObject);
typedef void (^HTNetworkCallback)(BOOL success, id responseObject);

typedef void (^SKResponseCallback)(BOOL success, SKResponsePackage *response);

#endif /* SKNetworkDefine_h */
