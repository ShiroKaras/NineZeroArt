//
//  HTImageView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTImageView.h"

@implementation HTImageView

- (void)setAnimatedImageWithName:(NSString *)name {
	[self setAnimatedImageWithName:name withLoopCount:1];
}

- (void)setAnimatedImageWithName:(NSString *)name withLoopCount:(NSInteger)loopCount {
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
	self.mImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]]];
	_frameCount = self.mImage.frameCount;
	self.mImage.loopCount = loopCount;
	self.animatedImage = self.mImage;
}

@end
