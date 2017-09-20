//
//  SKStorageManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKLoginUser;
@class SKUserInfo;
@class SKProfileInfo;

@interface SKStorageManager : NSObject

@property (nonatomic, strong) SKUserInfo *userInfo;
@property (nonatomic, strong) NSString *qiniuPublicToken;

+ (instancetype)sharedInstance;

// LoginUser
- (void)updateLoginUser:(SKLoginUser *)loginUser;
- (SKLoginUser *)getLoginUser;
- (void)clearLoginUser;

// user_id
- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;
- (void)clearUserID;

// Qiniu
- (void)setQiniuPublicToken:(NSString *)qiniuPublicToken;
- (NSString *)qiniuPublicToken;

@end
