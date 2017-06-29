//
//  HTAlertView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/27.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
	HTAlertViewTypeLocation,
	HTAlertViewTypePush,
	HTAlertViewTypePhotoLibrary,
	HTAlertViewTypeCamera,
	HTAlertViewTypeUnknown,
} HTAlertViewType;

@protocol HTAlertViewDelegate <NSObject>
- (void)didClickOKButton;
@end

@interface HTAlertView : UIView

@property (nonatomic, weak) id<HTAlertViewDelegate> delegate;

- (instancetype)initWithType:(HTAlertViewType)type;
- (void)show;

@end
