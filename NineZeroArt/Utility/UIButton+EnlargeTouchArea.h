//
//  UIButton+EnlargeTouchArea.h
//  wework
//
//  Created by HHHHTTTT on 15/9/7.
//  Copyright © 2015年 rdgz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

@interface UIButton (NoAnimEnableDisable)

- (void)setButtonEnabledNoAnimation:(BOOL)enabled;

@end

@interface UIImageView (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
