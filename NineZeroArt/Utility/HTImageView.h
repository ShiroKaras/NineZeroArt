//
//  HTImageView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import <UIKit/UIKit.h>

@interface HTImageView : FLAnimatedImageView

@property (nonatomic, strong) FLAnimatedImage *mImage;
@property (nonatomic, assign) NSInteger frameCount;

- (void)setAnimatedImageWithName:(NSString *)name;
- (void)setAnimatedImageWithName:(NSString *)name withLoopCount:(NSInteger)loopCount;

@end
