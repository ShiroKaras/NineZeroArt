//
//  HTWebController.h
//  NineZeroProject
//
//  Created by ShiroKaras on 16/4/5.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTWebController : UIViewController
- (instancetype)initWithURLString:(NSString *)urlString;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) int type;     //1.全屏
@end
