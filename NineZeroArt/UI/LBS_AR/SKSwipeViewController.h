//
//  SKSwipeViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "OpenGLView.h"
#import <UIKit/UIKit.h>

@class SKSwipeViewController;
@class SKScanning;

@protocol SKScanningViewDelegate <NSObject>
- (void)didClickBackButtonInScanningResultView:(SKSwipeViewController *)view;
@end

@interface SKSwipeViewController : UIViewController

@property (nonatomic, strong) OpenGLView *glView;
@property (nonatomic, weak) id<SKScanningViewDelegate> delegate;

- (instancetype)initWithScanning:(SKScanning*)scanning;

@end
