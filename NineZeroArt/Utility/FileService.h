//
//  FileService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject

+(float)fileSizeAtPath:(NSString *)path;

+(float)folderSizeAtPath:(NSString *)path;

+(void)clearCache:(NSString *)path;

+ (void)listFileAtPath:(NSString *)path;
@end
