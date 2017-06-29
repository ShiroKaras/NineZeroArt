//
//  SKImageHelper.h
//  NineZeroProject
//
//  Created by SinLemon on 16/5/26.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKImageHelper : NSObject

+ (UIImage *) getImageFromURL:(NSString *)fileURL;
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

@end
