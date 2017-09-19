//
//  NCPhotoView.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCPhotoView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image;
- (void)showPhoto;
@end
