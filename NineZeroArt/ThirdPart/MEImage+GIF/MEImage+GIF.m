//
//  MEImage+GIF.m
//  Test00
//
//  Created by Simon Len on 15/7/20.
//  Copyright (c) 2015年 Simon Len. All rights reserved.
//

#import "MEImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (GIF)


+ (NSArray*)startImageAtPercent:(float)percent withGIF:(NSData*)imageData{
    percent = percent>0? percent:0;
    percent = percent>1? percent/100.0:percent;
    NSArray *imagesArray = [self animatedGIFWithData:imageData];
    int index = [imagesArray count]*percent;
    return [self startImageAtIndex:index with:imagesArray];
}

+ (NSArray*)startImageAtIndex:(unsigned)index withGIF:(NSData*)imageData{
    NSArray *imagesArray = [self animatedGIFWithData:imageData];
    return [self startImageAtIndex:index with:imagesArray];
}

+ (NSArray*)startImageAtIndex:(unsigned)index with:(NSArray*)imagesArray{
    
    NSMutableArray *mImagesArray = [NSMutableArray arrayWithArray:imagesArray];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i= 0; i<index; i++) {
        [tempArray addObject:mImagesArray[i]];
    }
    
    [mImagesArray removeObjectsInArray:tempArray];
    [mImagesArray addObjectsFromArray:tempArray];
    
    return [NSArray arrayWithArray:mImagesArray];
}

- (void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pauseTime;
}

- (void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pauseTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil]-pauseTime;
    layer.beginTime = timeSincePause;
}

+ (NSArray *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    NSMutableArray *images = [NSMutableArray array];
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self frameDurationAtIndex:i source:source];
            
            //            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            [images addObject:[UIImage imageWithCGImage:image]];
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        NSLog(@"%f", duration);
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
        
        //        gifImageView.image = animatedImage;
        //        gifImageView.animationImages = [NSArray arrayWithArray:images];
        //        gifImageView.animationDuration = duration;
        //        gifImageView.animationRepeatCount = 0;
    }
    
    CFRelease(source);
    //return animatedImage;
    return [NSArray arrayWithArray:images];
}

+(float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
