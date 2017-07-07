//
//  SKCGIManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServerConfiguration.h"

@interface SKCGIManager : NSObject

+ (NSString *)loginBaseCGIKey;

+ (NSString *)profileBaseCGIKey;

+ (NSString *)commonBaseCGIKey;

+ (NSString *)shareBaseCGIKey;

+ (NSString *)scanningBaseCGIKey;

@end
