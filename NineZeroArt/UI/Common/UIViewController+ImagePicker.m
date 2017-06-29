//
//  UIViewController+ImagePicker.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/22.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUI.h"
#import "HTAlertView.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>

static char *kAssociatedKey;

@implementation UIViewController (ImagePicker)

- (void)presentSystemCameraController {
	[self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)presentSystemPhotoLibraryController {
	[self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType {
	if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:
							  [UIColor whiteColor], NSForegroundColorAttributeName,
							  nil];
		imagePicker.navigationBar.titleTextAttributes = size;
		imagePicker.navigationBar.translucent = NO;
		[imagePicker.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:0x1a1a1a]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
		imagePicker.navigationBar.shadowImage = [UIImage new];
		[imagePicker.navigationBar setTintColor:[UIColor whiteColor]];
		imagePicker.delegate = self;
		imagePicker.sourceType = sourceType;
		imagePicker.allowsEditing = YES;
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                //无权限访问相册
                HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypePhotoLibrary];
                [alertView show];
            }
            else
                [self presentViewController:imagePicker animated:YES completion:nil];
        } else if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusAuthorized) {
                [self presentViewController:imagePicker animated:YES completion:nil];
            } else if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                }];
            }
            else {
                HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypePhotoLibrary];
                [alertView show];
            }
        }
        
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// 保证statusBar的颜色
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    viewController.view.backgroundColor = [UIColor blackColor];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [viewController.navigationController.viewControllers count] > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.width += 10;
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(button, kAssociatedKey, viewController.navigationController, OBJC_ASSOCIATION_RETAIN);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 保证statusBar的颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    viewController.view.backgroundColor = [UIColor blackColor];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && [viewController.navigationController.viewControllers count] > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.width += 10;
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(button, kAssociatedKey, viewController.navigationController, OBJC_ASSOCIATION_RETAIN);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)back:(UIButton *)back {
    UINavigationController *nav = objc_getAssociatedObject(back, kAssociatedKey);
    [nav popViewControllerAnimated:YES];
}

@end
