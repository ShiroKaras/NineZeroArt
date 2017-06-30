//
//  SKPopupGetPuzzleView.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKPopupGetPuzzleView;
@protocol SKPopupGetPuzzleViewDelegate <NSObject>
@optional

- (void)didRemoveFromSuperView;

@end

@interface SKPopupGetPuzzleView : UIView

@property (nonatomic, weak) id delegate;

- (instancetype)initWithPuzzleImageURL:(NSString *)imageURL;

@end
