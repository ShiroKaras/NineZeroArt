//
//  HTUIHelper.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTUIHelper.h"
#import "HTUIHeader.h"

@implementation HTUIHelper
+ (UIBarButtonItem *)commonLeftBarItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left_highlight"] forState:UIControlStateHighlighted];
    [button sizeToFit];
    button.width += 10;
    [button addTarget:self action:@selector(onClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (void)onClickBackButton:(UIButton *)button {
    UIViewController *controller = UIViewParentController(button);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//+ (SKIndexViewController *)mainController {
//    return AppDelegateInstance.mainController;
//}

@end
