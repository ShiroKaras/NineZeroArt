//
//  NAClueListViewController.h
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/3.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAClueListViewController : UIViewController

@end


@interface NAClueCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@end
