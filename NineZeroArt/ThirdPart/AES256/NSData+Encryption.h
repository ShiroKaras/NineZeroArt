//
//  NSData+AES256.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)
- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;

@end
