//
//  NAAboutViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/7/10.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NAAboutViewController.h"
#import "HTUIHeader.h"
#import <MessageUI/MessageUI.h>

@interface NAAboutViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic,strong)  MFMailComposeViewController *mailComposer;
@end

@implementation NAAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_aboutpage_titletext"]];
    [headerView addSubview:headerImageView];
    headerImageView.centerX = headerView.centerX;
    headerImageView.centerY = headerView.height/2;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_aboutpage_logo"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    logoImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(80), ROUND_WIDTH_FLOAT(80));
    logoImageView.centerX = self.view.centerX;
    logoImageView.top = headerImageView.bottom;
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = [NSString stringWithFormat:@"529D艺术 版本%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    [textLabel sizeToFit];
    [self.view addSubview:textLabel];
    textLabel.top = logoImageView.bottom+3;
    textLabel.centerX = self.view.centerX;
    
    UIButton *contactUsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, textLabel.bottom+ROUND_HEIGHT_FLOAT(35), self.view.width, ROUND_HEIGHT_FLOAT(50))];
    [contactUsButton setBackgroundImage:[UIImage imageWithColor:COMMON_TITLE_BG_COLOR] forState:UIControlStateNormal];
    [contactUsButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
    [contactUsButton setImage:[UIImage imageNamed:@"btn_aboutpage_business"] forState:UIControlStateNormal];
    [contactUsButton setImage:[UIImage imageNamed:@"btn_aboutpage_business_highlight"] forState:UIControlStateHighlighted];
    [contactUsButton addTarget:self action:@selector(didClickContactUsButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactUsButton];
}

- (void)didClickContactUsButton:(UIButton*)sender {
    
    
    NSString *email = @"mkt@90app.tv";
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
    } else { return; }
    
    if ([MFMessageComposeViewController canSendText] == YES) {
        _mailComposer = [[MFMailComposeViewController alloc]init];
        _mailComposer.mailComposeDelegate = self;
        [_mailComposer setSubject:@""];
        NSArray *arr = @[email];
        //收件人
        [_mailComposer setToRecipients:arr];
        // 设置邮件主题
        //[_mailComposer setSubject:@"我是邮件主题"];
        // 设置密抄送
        //[_mailComposer setBccRecipients:@[@"shana_happy@126.com"]];
        // 设置抄送人
        //[_mailComposer setCcRecipients:@[@"1229436624@qq.com"]];
        // 如使用HTML格式，则为以下代码
        //    [_mailComposer setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
        /*
         //添加附件
         UIImage *image = [UIImage imageNamed:@"image"];
         NSData *imageData = UIImagePNGRepresentation(image);
         [_mailComposer addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
         NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
         NSData *pdf = [NSData dataWithContentsOfFile:file];
         [_mailComposer addAttachmentData:pdf mimeType:@"" fileName:@"7天精通iOS"];
         */
        
        //[_mailComposer setMessageBody:@"你好,很高兴认识你" isHTML:NO];
        [self presentViewController:_mailComposer animated:YES completion:nil];
    }else{
        
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        DLog(@"Result : %ld",(long)result);
    }
    if (error) {
        DLog(@"Error : %@",error);
    }
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            DLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            DLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            DLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            DLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
