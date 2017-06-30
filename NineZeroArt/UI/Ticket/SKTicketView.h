//
//  SKTicketView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTicket;

@interface SKTicketView : UIView

- (instancetype)initWithFrame:(CGRect)frame reward:(SKTicket*)reward;

@end
