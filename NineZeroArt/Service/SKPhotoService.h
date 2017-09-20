//
//  SKPhotoService.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKLogicHeader.h"

@interface SKPhotoService : NSObject

- (void)uploadPhotoWithURL:(NSString *)url Callback:(SKResponseCallback)callback;

- (void)showPhotoCallback:(SKResponseCallback)callback;

@end
