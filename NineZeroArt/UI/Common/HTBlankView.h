//
//  HTBlankView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/21.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTBlankViewType) {
    HTBlankViewTypeNetworkError,
    HTBlankViewTypeNoContent,
    HTBlankViewTypeUnknown,
};

@interface HTBlankView : UIView
// 默认为大，深色，宽度一定为屏幕宽度
- (instancetype)initWithType:(HTBlankViewType)type;
- (instancetype)initWithImage:(UIImage*)image text:(NSString*)text;
- (void)setImage:(UIImage *)image andOffset:(CGFloat)offset;
- (void)setOffset:(CGFloat)offset;

@end
