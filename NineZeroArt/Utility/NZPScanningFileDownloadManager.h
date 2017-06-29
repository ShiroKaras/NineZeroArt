//
//  NZPScanningFileDownloadManager.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZPScanningFileDownloadManager : NSObject

+ (instancetype)manager;

+ (void)downloadZip:(NSString *)downloadKey
		 progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
	completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

// 检查Cache目录下是否存在zip文件
+ (BOOL)isZipFileExistsWithFileName:(NSString *)zipFileName;

// 检查Cache目录下是否存在zip文件对应的
+ (BOOL)isUnZipFileExistsWithFileName:(NSString *)zipFileName;

- (void)downloadVideoWithURL:(NSURL *)videoFileURL
		    progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
		 destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
	   completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
