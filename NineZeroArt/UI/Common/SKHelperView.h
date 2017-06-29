//
//  SKHelperView.h
//  NineZeroProject
//
//  Created by SinLemon on 16/9/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKHelperTypeHasMascot,
    SKHelperTypeNoMascot,
} SKHelperType;

@class SKHelperView;

@protocol SKHelperViewDelegate <NSObject>
@optional
- (void)didClickNextStepButtonInView:(SKHelperView *)view type:(SKHelperType)type index:(NSInteger)index;
@end

@interface SKHelperView : UIView
@property (nonatomic, strong) UIButton *nextstepButton;
@property (nonatomic, weak) id<SKHelperViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperType)type index:(NSInteger)index;
- (void)setImage:(UIImage *)image andText:(NSString *)text;
- (void)setVideoName:(NSString *)videoName andText:(NSString *)text;
- (void)play;
- (void)pause;
@end



//ScrollView
typedef enum : NSUInteger {
    SKHelperScrollViewTypeQuestion,
    SKHelperScrollViewTypeTimeLimitQuestion,
    SKHelperScrollViewTypeMascot,
    SKHelperScrollViewTypeAR
} SKHelperScrollViewType;

@protocol SKHelperScrollViewDelegate <NSObject>
- (void)didClickCompleteButton;
@end

@interface SKHelperScrollView : UIView
@property (nonatomic, weak) id<SKHelperScrollViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dimmingView;
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperScrollViewType)type;
@end



//Guide
typedef enum : NSUInteger {
    SKHelperGuideViewType1,
    SKHelperGuideViewTypeMascot1,
    SKHelperGuideViewTypeMascot2,
    SKHelperGuideViewTypeTaskList,
    SKHelperGuideViewTypeTaskDetail,
    SKHelperGuideViewTypeLBS
} SKHelperGuideViewType;

@interface SKHelperGuideView : UIView
@property (nonatomic, strong) UIButton *button3;
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperGuideViewType)type;
@end
