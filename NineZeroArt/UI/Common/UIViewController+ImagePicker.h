//
//  UIViewController+ImagePicker.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/22.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImagePicker)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)presentSystemCameraController;
- (void)presentSystemPhotoLibraryController;

@end
