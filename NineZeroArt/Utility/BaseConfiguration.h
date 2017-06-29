//
//  BaseConfiguration.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/17.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseConfiguration : NSObject

@property (nonatomic, strong) NSDictionary *configs;

+ (instancetype)sharedInstance;

+ (NSString *)funny;

- (void)loadConfigWithFileName:(NSString *)filename;

- (int)intValueWithKey:(NSString *)key;

- (BOOL)boolValueWithKey:(NSString *)key;

- (float)floatValueWithKey:(NSString *)key;

- (id)idValueWithKey:(NSString *)key;

- (NSString *)stringValueWithKey:(NSString *)key;

- (NSDictionary *)dictionaryValueWithKey:(NSString *)key;

- (NSArray *)arrayValueWithKey:(NSString *)key;

@end
