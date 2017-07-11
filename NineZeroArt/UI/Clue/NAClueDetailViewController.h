//
//  NAClueDetailViewController.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/5.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKScanning;

@interface NAClueDetailViewController : UIViewController
@property (nonatomic, strong) SKScanning *scanning;

- (instancetype)initWithScanning:(SKScanning*)scanning urlString:(NSString*)urlString;

@end
