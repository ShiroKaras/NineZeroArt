//
//  SKScanningResultView.H
//  NineZeroProject
//
//  Created by SinLemon on 16/10/10.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScanningResultView;

@interface SKScanningResultView : UIView

- (instancetype)initWithFrame:(CGRect)frame withIndex:(NSUInteger)index swipeType:(int)type;

@end
