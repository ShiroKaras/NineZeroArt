//
//  NCPhotoView.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/15.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConfiguration.h"

#define SHARE_URL(u) [NSString stringWithFormat:@"https://90app.tv/otime/h5/share/photo/u_id=%@/from_client=true", (u)]

@interface NCPhotoView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image imageURL:(NSString*)imageURL time:(NSString*)time showAnimation:(BOOL)flag;
- (void)showPhoto;
@end
