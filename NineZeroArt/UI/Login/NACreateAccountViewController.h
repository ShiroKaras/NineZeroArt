//
//  NACreateAccountViewController.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/5.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKLoginUser;

@interface NACreateAccountViewController : UIViewController
- (instancetype)initWithLoginUser:(SKLoginUser*)loginUser;
@end
