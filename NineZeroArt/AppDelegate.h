//
//  AppDelegate.h
//  NineZeroCamera
//
//  Created by SinLemon on 2017/6/29.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "NAClueListViewController.h"
#import "NALoginRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NAClueListViewController *mainController;
@property (nonatomic, strong) NSString *cityCode;
@property (atomic) bool active;
    
- (void)saveContext;

@end

