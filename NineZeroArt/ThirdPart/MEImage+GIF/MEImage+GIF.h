//
//  MEImage+GIF.h
//  Test00
//
//  Created by Simon Len on 15/7/20.
//  Copyright (c) 2015年 Simon Len. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (NSArray*)startImageAtPercent:(float)percent withGIF:(NSData*)imageData;
+ (NSArray*)startImageAtIndex:(unsigned)index withGIF:(NSData*)imageData;

@end
