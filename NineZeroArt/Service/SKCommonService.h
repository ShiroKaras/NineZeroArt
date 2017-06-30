//
//  SKCommonService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

@class SKIndexInfo;

typedef void (^SKGetTokenCallback) (BOOL success, NSString *token);
typedef void (^SKIndexInfoCallback) (BOOL success, SKIndexInfo *indexInfo);
typedef void (^SKIndexScanningCallback) (BOOL success, SKIndexScanning *indexScanningInfo);

@interface SKCommonService : NSObject

// Qiniu Token
- (void)getQiniuPublicTokenWithCompletion:(SKGetTokenCallback)callback;

// 获取文件完整地址

/**
 *  @brief 获取七牛下载链接
 *  @param keys      服务器给的key
 */
- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback;

@end
