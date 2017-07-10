//
//  NACreateAccountViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/5.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NACreateAccountViewController.h"
#import "HTUIHeader.h"

#import "NAClueListViewController.h"

@interface NACreateAccountViewController ()
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SKLoginUser *loginUser;
@end

@implementation NACreateAccountViewController

- (instancetype)initWithLoginUser:(SKLoginUser*)loginUser
{
    self = [super init];
    if (self) {
        self.loginUser = loginUser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 49)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_titletext2"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
    _avatarButton.layer.cornerRadius = ROUND_WIDTH_FLOAT(32);
    _avatarButton.layer.masksToBounds = YES;
    [_avatarButton setBackgroundImage:[UIImage imageNamed:@"img_profile_photo_default"] forState:UIControlStateNormal];
    [_avatarButton addTarget:self action:@selector(presentSystemPhotoLibraryController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_avatarButton];
    _avatarButton.centerX = self.view.centerX;
    _avatarButton.top = headerView.bottom +ROUND_HEIGHT_FLOAT(20);
    
    _usernameLabel = [UILabel new];
    _usernameLabel.text = @"点击设置头像";
    _usernameLabel.textColor = [UIColor whiteColor];
    _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
    [_usernameLabel sizeToFit];
    [self.view addSubview:_usernameLabel];
    _usernameLabel.top = _avatarButton.bottom +ROUND_HEIGHT_FLOAT(20);
    _usernameLabel.centerX = _avatarButton.centerX;
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _usernameLabel.bottom+32, self.view.width, 60)];
    _usernameTextField.placeholder = @"请输入昵称";
    _usernameTextField.textColor = COMMON_TEXT_2_COLOR;
    [_usernameTextField setValue:COMMON_TEXT_2_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _usernameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 60)];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_usernameTextField];
    [_usernameTextField becomeFirstResponder];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(16, _usernameTextField.bottom, self.view.width-32, 1)];
    line1.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:line1];
    
    _nextButton = [UIButton new];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_login2"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_login2_highlight"] forState:UIControlStateHighlighted];
    _nextButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_nextButton];
}

- (void)nextButtonClick:(UIButton *)sender {
    if (_usernameTextField.text.length == 0) {
        [self showTipsWithText:@"用户名不得为空"];
    }
    self.loginUser.user_name = _usernameTextField.text;
    [[[SKServiceManager sharedInstance] loginService] registerWith:self.loginUser callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            NAClueListViewController *controller =  [[NAClueListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:NO];
        }
    }];
}

- (void)textFieldTextDidChange:(UITextField *)textField {
    if (_usernameTextField.text.length>10) {
        [self showTipsWithText:@"用户名不得超过10个字符"];
        _usernameTextField.text = [_usernameTextField.text substringToIndex:10];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 50, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];
    
    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"处理中" animated:YES];
    NSString *avatarKey = [NSString avatarName];
    
    [[[SKServiceManager sharedInstance] qiniuService] putData:imageData key:avatarKey token:[[SKStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        if (info.statusCode == 200) {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            self.loginUser.user_avatar = [NSString qiniuDownloadURLWithFileName:key];
            [_avatarButton setBackgroundImage:image forState:UIControlStateNormal];
//            [[[SKServiceManager sharedInstance] profileService] updateUserInfoWith:_userInfo withType:0 callback:^(BOOL success, SKResponsePackage *response) {
//                [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
//                if (success) {
//                    [_avatarButton setBackgroundImage:image forState:UIControlStateNormal];
//                } else {
//                    [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0];
//                }
//            }];
        } else {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0];
        }
    } option:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
