//
//  AppDelegate.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/6/29.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "AppDelegate.h"
#import "HTLogicHeader.h"
#import "HTNavigationController.h"
#import "HTUIHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _cityCode = @"010";
    _active = true;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self registerQiniuService];
    
    [NSThread sleepForTimeInterval:2];
    [self createWindowAndVisibleWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    _active = false;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"NineZeroArt"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)createWindowAndVisibleWithOptions:(NSDictionary *)launchOptions {
    NSString *userID = [[SKStorageManager sharedInstance] getUserID];
    if (userID != nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _mainController = [[NAClueListViewController alloc] init];
        HTNavigationController *navController =
        [[HTNavigationController alloc] initWithRootViewController:_mainController];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        NALoginRootViewController *rootController = [[NALoginRootViewController alloc] init];
        HTNavigationController *navController =
        [[HTNavigationController alloc] initWithRootViewController:rootController];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        
        //		if (![UD boolForKey:@"everLaunch"]) {
        //			self.launchViewController = [[SKLaunchAnimationViewController alloc] init];
        //			[self.window addSubview:self.launchViewController.view];
        //			__weak AppDelegate *weakSelf = self;
        //			self.launchViewController.didSelectedEnter = ^() {
        //			    [UIView animateWithDuration:0.3
        //				    animations:^{
        //					weakSelf.launchViewController.view.alpha = 0;
        //				    }
        //				    completion:^(BOOL finished) {
        //					weakSelf.launchViewController = nil;
        //					//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        //				    }];
        //			};
        //		} else {
        //			//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        //		}
        
        [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
    }
}

#pragma mark - QiNiu

- (void)registerQiniuService {
    [[[SKServiceManager sharedInstance] commonService]
     getQiniuPublicTokenWithCompletion:^(BOOL success, NSString *token){
     }];
}

@end
