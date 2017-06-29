//
//  NSString+AES256.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(AES256)

- (NSString *)aes256_encrypt:(NSString *)key;
- (NSString *)aes256_decrypt:(NSString *)key;

@end
