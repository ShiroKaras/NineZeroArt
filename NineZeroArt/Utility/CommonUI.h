//
//  CommonUI.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/2.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef CommonUI_h
#define CommonUI_h

#pragma mark - 方法-C对象、结构操作
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child)
{
    return (parent - child) / 2;
}

CG_INLINE CGFloat
CGFloatAlignPixel(CGFloat value)
{
    static CGFloat scale = 0;
    if (scale == 0) {
        scale = [UIScreen mainScreen].scale;
    }
    return roundf(value * scale) / scale;
}

CG_INLINE CGSize
CGSizeAlignPixel(CGSize size)
{
    return CGSizeMake(CGFloatAlignPixel(size.width), CGFloatAlignPixel(size.height));
}

CG_INLINE CGSize
CGSizeAlignMake(CGFloat width, CGFloat height)
{
    return CGSizeMake(CGFloatAlignPixel(width), CGFloatAlignPixel(height));
}

CG_INLINE CGFloat
CGRectHorizontalCenter(CGRect parentRect, CGRect childRect)
{
    return (CGRectGetWidth(parentRect) - CGRectGetWidth(childRect)) / 2;
}

CG_INLINE CGFloat
CGRectVerticalCenter(CGRect parentRect, CGRect childRect)
{
    return (CGRectGetHeight(parentRect) - CGRectGetHeight(childRect)) / 2;
}

CG_INLINE CGRect
CGRectMakeWithSize(CGSize size)
{
    return CGRectMake(0, 0, size.width, size.height);
}

CG_INLINE CGRect
CGRectPadding(CGRect rect, CGFloat padding, CGFloat limit)
{
    CGFloat width = rect.size.width;
    width += padding;
    if (width < limit) width = limit;
    rect.size.width = width;
    return rect;
}

CG_INLINE CGRect
CGRectFloatTop(CGRect rect, CGRect target, CGFloat padding)
{
    rect.origin.y = target.origin.y + padding;
    return rect;
}

CG_INLINE CGRect
CGRectFloatBottom(CGRect rect, CGRect target, CGFloat padding)
{
    rect.origin.y = target.origin.y + target.size.height + padding;
    return rect;
}

// 保持rect的宽度不变，改变其x，使右边缘靠在right上
CG_INLINE CGRect
CGRectFloatRight(CGRect rect, CGFloat right)
{
    rect.origin.x = right - rect.size.width;
    return rect;
}

CG_INLINE CGRect
CGRectFloatLeft(CGRect rect, CGFloat left)
{
    rect.origin.x = left;
    return rect;
}

CG_INLINE CGRect
CGRectFloatAfter(CGRect rect, CGRect target, CGFloat padding)
{
    rect.origin.x = target.origin.x + target.size.width + padding;
    return rect;
}

CG_INLINE CGRect
CGRectExtendToBottom(CGRect rect, CGRect target, CGFloat padding)
{
    rect.size.height = target.origin.y + target.size.height + padding;
    return rect;
}

CG_INLINE CGRect
CGRectExtendToRight(CGRect rect, CGRect target, CGFloat padding)
{
    rect.size.width = target.origin.x + target.size.width + padding;
    return rect;
}

// 保持rect的左边缘不变，改变其宽度，使右边缘靠在right上
CG_INLINE CGRect
CGRectLimitRight(CGRect rect, CGFloat right)
{
    rect.size.width = right - rect.origin.x;
    return rect;
}

// 保持rect右边缘不变，改变其宽度和origin.x，使其左边缘靠在left上。只适合那种右边缘不动的view
// 先改变origin.x，让其靠在offset上
// 再改变size.width，减少同样的宽度，以抵消改变origin.x带来的view移动，从而保证view的右边缘是不动的
CG_INLINE CGRect
CGRectLimitLeft(CGRect rect, CGFloat leftOffset)
{
    CGFloat subOffset = leftOffset - rect.origin.x;
    rect.origin.x = leftOffset;
    rect.size.width = rect.size.width - subOffset;
    return rect;
}


CG_INLINE CGRect
CGRectSetXY(CGRect rect, CGFloat x, CGFloat y)
{
    rect.origin.x = x;
    rect.origin.y = y;
    return rect;
}
CG_INLINE CGRect
CGRectLimitWidth(CGRect rect, CGFloat width)
{
    rect.size.width = rect.size.width > width ? width : rect.size.width;
    return rect;
}

CG_INLINE CGRect
CGRectSetHeight(CGRect rect, CGFloat height)
{
    rect.size.height = height;
    return rect;
}
CG_INLINE CGRect
CGRectSetX(CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect
CGRectSetY(CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    return rect;
}
CG_INLINE CGRect
CGRectSetWidth(CGRect rect, CGFloat width)
{
    rect.size.width = width;
    return rect;
}

CG_INLINE CGRect
CGRectAlignPixel(CGRect rect)
{
    return CGRectMake(CGFloatAlignPixel(rect.origin.x),
                      CGFloatAlignPixel(rect.origin.y),
                      CGFloatAlignPixel(rect.size.width),
                      CGFloatAlignPixel(rect.size.height));
}

CG_INLINE CGRect
CGRectAlignMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    return CGRectMake(CGFloatAlignPixel(x),
                      CGFloatAlignPixel(y),
                      CGFloatAlignPixel(width),
                      CGFloatAlignPixel(height));
}

CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets)
{
    return insets.left + insets.right;
}

CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets)
{
    return insets.top + insets.bottom;
}

CG_INLINE UIEdgeInsets
UIEdgeInsetsSetTop(UIEdgeInsets insets, CGFloat top)
{
    insets.top = top;
    return insets;
}

CG_INLINE UIEdgeInsets
UIEdgeInsetsSetLeft(UIEdgeInsets insets, CGFloat left)
{
    insets.left = left;
    return insets;
}
CG_INLINE UIEdgeInsets
UIEdgeInsetsSetBottom(UIEdgeInsets insets, CGFloat bottom)
{
    insets.bottom = bottom;
    return insets;
}

CG_INLINE UIEdgeInsets
UIEdgeInsetsSetRight(UIEdgeInsets insets, CGFloat right)
{
    insets.right = right;
    return insets;
}

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha;
@end

@interface UIImage (Utility)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end

@interface UIView (HTAdd)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end

#endif /* CommonUI_h */
