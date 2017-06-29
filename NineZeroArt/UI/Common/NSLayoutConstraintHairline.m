//
//  NSLayoutConstraintHairline.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "NSLayoutConstraintHairline.h"

@implementation NSLayoutConstraintHairline

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant == 1) self.constant = 1/[UIScreen mainScreen].scale;
}

@end
