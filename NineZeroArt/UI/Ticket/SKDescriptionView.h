//
//  SKDescriptionView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKDescriptionTypeQuestion,  // defalut
    SKDescriptionTypeProp,
    SKDescriptionTypeReward,
    SKDescriptionTypeBadge,
    SKDescriptionTypeUnknown,
} SKDescriptionType;

@class SKDescriptionView;
@class SKMascotProp;
@class SKTicket;
@class SKBadge;

@protocol SKDescriptionViewDelegate <NSObject>
- (void)descriptionView:(SKDescriptionView *)descView didChangeProp:(SKMascotProp *)prop;
@end

@interface SKDescriptionView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type;
- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type andImageUrl:(NSString *)imageUrlString;

- (void)showAnimated;

@property (nonatomic, assign, readonly) SKDescriptionType type;
@property (nonatomic, strong) SKMascotProp *prop;
@property (nonatomic, strong) SKTicket *reward;
@property (nonatomic, strong) SKBadge *badge;

@property (nonatomic, weak) id<SKDescriptionViewDelegate> delegate;



@end
