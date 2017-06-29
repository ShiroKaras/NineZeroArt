//
//  NZPScanningFileDownloadManager.m
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZPScanningFileDownloadManager.h"
#import "SKServiceManager.h"
#import <AFNetworking.h>

@implementation NZPScanningFileDownloadManager {
	NSMutableSet *_downloadTaskURLs;
}

- (instancetype)init {
	if (self = [super init]) {
		_downloadTaskURLs = [NSMutableSet new];
	}
	return self;
}

+ (instancetype)manager {
	static id manager;
	if (!manager) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
		    manager = [[self alloc] init];
		});
	}
	return manager;
}

+ (void)downloadZip:(NSString *)downloadKey
		 progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
	completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
	[[[SKServiceManager sharedInstance] commonService] getQiniuDownloadURLsWithKeys:@[downloadKey]
									       callback:^(BOOL success, SKResponsePackage *response) {
										   if (success) {
											   NSDictionary *dic = response.data;
											   for (NSString *key in dic) {
												   NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
												   AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

												   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[dic objectForKey:key]]];

												   NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
																				    progress:downloadProgressBlock
																				 destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
																				     NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
																				     return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
																				 }
																			   completionHandler:completionHandler];
												   [downloadTask resume];
											   }
										   } else {
											   // 获取zip地址失败
											   NSLog(@"获取zip地址失败");
										   }
									       }];
}

+ (BOOL)isZipFileExistsWithFileName:(NSString *)zipFileName {
	NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
	documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:zipFileName];
	return [[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL.relativePath];
}

+ (BOOL)isUnZipFileExistsWithFileName:(NSString *)zipFileName {
	NSString *fileName = [[zipFileName lastPathComponent] stringByDeletingPathExtension];
	NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
	documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
	return [[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryURL.relativePath];
}

- (void)downloadVideoWithURL:(NSURL *)videoFileURL
		    progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
		 destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
	   completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
	if ([_downloadTaskURLs containsObject:videoFileURL]) {
		return;
	}

	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

	NSURLRequest *request = [NSURLRequest requestWithURL:videoFileURL];

	NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
									 progress:downloadProgressBlock
								      destination:destination
								completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
								    [_downloadTaskURLs removeObject:videoFileURL];
								    completionHandler(response, filePath, error);
								}];
	[downloadTask resume];

	[_downloadTaskURLs addObject:videoFileURL];
}

@end
