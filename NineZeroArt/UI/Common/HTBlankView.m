//
//  HTBlankView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/21.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTBlankView.h"
#import "HTUIHeader.h"

@interface HTBlankView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) HTBlankViewType type;
@property (nonatomic, assign) CGFloat offset;
@end

@implementation HTBlankView

- (instancetype)initWithType:(HTBlankViewType)type {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)]) {
        _type = type;
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_blank_grey_big"]];;
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor colorWithHex:0x878787];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = (type == HTBlankViewTypeNetworkError) ? @"网络不给力" : @"空空如也";
        [self addSubview:_label];
        [_label sizeToFit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)image text:(NSString*)text {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithImage:image];;
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor colorWithHex:0x878787];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = text;
        [self addSubview:_label];
        [_label sizeToFit];
    }
    return self;
}

- (void)setImage:(UIImage *)image andOffset:(CGFloat)offset {
    _imageView.image = image;
    _offset = offset;
    [self setNeedsLayout];
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_imageView sizeToFit];
    _imageView.centerX = self.centerX;
    _imageView.top = 0;
    _label.top = _imageView.bottom + _offset;
    _label.centerX = _imageView.centerX;
}

@end
