//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

@implementation SKCGIManager

+ (NSString *)loginBaseCGIKey {
	return [NSString stringWithFormat:@"%@/otime/api/login/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)photoBaseCGIKey {
	return [NSString stringWithFormat:@"%@/otime/api/photo/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)shareBaseCGIKey {
	return [NSString stringWithFormat:@"%@/otime/h5/share/photo", [[ServerConfiguration sharedInstance] appHost]];
}

+ (NSString *)qiniuBaseCGIKey {
    return [NSString stringWithFormat:@"%@/otime/api/qiNiu/appIndex", [[ServerConfiguration sharedInstance] appHost]];
}
@end
