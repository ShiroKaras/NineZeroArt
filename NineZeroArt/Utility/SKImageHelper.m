//
//  SKImageHelper.m
//  NineZeroProject
//
//  Created by SinLemon on 16/5/26.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKImageHelper.h"

@implementation SKImageHelper

+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
        NSLog(@"image len -> %lu", (unsigned long)[imageData length]);
    }
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
@end
