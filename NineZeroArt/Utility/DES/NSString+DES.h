//
//  NSString+DES.h
//  AES
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(DES)

+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key;

@end
