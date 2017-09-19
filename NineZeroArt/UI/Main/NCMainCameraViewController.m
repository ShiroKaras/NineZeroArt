//
//  NCMainCameraViewController.m
//  NineZeroArt
//
//  Created by SinLemon on 2017/9/12.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NCMainCameraViewController.h"
#import "HTUIHeader.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AudioToolbox/AudioToolbox.h>

#import "FWApplyFilter.h"
#import "NCPhotoView.h"
#import "UIImage+FW.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface NCMainCameraViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UISegmentedControl *switchCarmeraSegment;
@property (strong, nonatomic) UIBarButtonItem *flashButton;

//AVFoundation
@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 *  记录开始的缩放比例
 */
@property (nonatomic, assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property (nonatomic, assign) CGFloat effectiveScale;

@property (nonatomic, strong) UIImageView *flashButtonImageView;
@property (nonatomic, strong) UIImageView *cameraImageView;
@property (nonatomic, strong) UIButton *takePhotoButton;
@end

@implementation NCMainCameraViewController{
    BOOL isUsingFrontFacingCamera;
    BOOL isUsingFlashLight;
    AVCaptureDevice *device;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT+100, SCREEN_WIDTH)];
    [self.view addSubview:_backView];
    
    [self initAVCaptureSession];
    [self setUpGesture];
    isUsingFrontFacingCamera = NO;
    
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
    self.cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_homepage_background_%lf", MIN(SCREEN_WIDTH, SCREEN_HEIGHT)]]];
    [self.backView addSubview:self.cameraImageView];
    self.cameraImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.flashButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_homepage_flashlamp"]];
    [self.backView addSubview:self.flashButtonImageView];
    self.flashButtonImageView.left = 49+100+66.5;
    self.flashButtonImageView.top = 80.5;
    
    UIButton *flashButton = [UIButton new];
    [flashButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:flashButton];
    flashButton.size = CGSizeMake(93.5, 25);
    flashButton.left = self.flashButtonImageView.left;
    flashButton.top = self.flashButtonImageView.top;
    isUsingFlashLight = NO;
    [device lockForConfiguration:nil];
    [device setTorchMode: AVCaptureTorchModeOff];
    device.flashMode = AVCaptureFlashModeOff;
    [device unlockForConfiguration];
    
    self.takePhotoButton = [UIButton new];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_shutter"] forState:UIControlStateNormal];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_shutter_highlight"] forState:UIControlStateHighlighted];
    [self.takePhotoButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.takePhotoButton];
    self.takePhotoButton.size = CGSizeMake(58, 58);
    self.takePhotoButton.left = self.view.height-81-58;
    self.takePhotoButton.top = 54;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;//时间
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    [UIView commitAnimations];
    self.backView.transform = CGAffineTransformIdentity;
    self.backView.transform = CGAffineTransformMakeRotation(M_PI*.5);//翻转角度
    self.backView.bounds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height+100, [[UIScreen mainScreen] bounds].size.width);
    self.backView.top = 0;
    self.backView.left = 0;
    
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }
    return;
}

#pragma mark private method
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeOn];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(self.view.width-10.5-100, 49, 100, 100/SCREEN_WIDTH*SCREEN_HEIGHT);
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.backView.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.previewLayer];
    [self.view bringSubviewToFront:self.backView];
}


- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

#pragma 创建手势
- (void)setUpGesture{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.backView addGestureRecognizer:pinch];
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark respone method
//切换镜头
- (void)switchCameraSegmentedControlClick:(UISegmentedControl *)sender {
    
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)takePhotoButtonClick:(UIBarButtonItem *)sender {
    // 声明要保存音效文件的变量
    SystemSoundID soundID;
    //快门声
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"flash" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &soundID);
    // 播放短频音效
    AudioServicesPlayAlertSound(soundID);
    // 增加震动效果，如果手机处于静音状态，提醒音将自动触发震动
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    NSLog(@"takephotoClick...");
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
//        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
//                                                                    imageDataSampleBuffer,
//                                                                    kCMAttachmentMode_ShouldPropagate);
//        
//        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
//            //无权限
//            return ;
//        }
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//        }];
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *cropImage = [[UIImage imageWithData:imageData] cropImageWithBounds:CGRectMake(0, 0, 1080, 1080)];
        UIImage * image = [FWApplyFilter applyNashvilleFilter:cropImage];
        
        NCPhotoView *photoView = [[NCPhotoView alloc] initWithFrame:self.view.bounds withImage:image];
        [self.view addSubview:photoView];
        [self.view bringSubviewToFront:self.backView];
        
        self.takePhotoButton.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            self.backView.top = -511;
            
            float scale = 0;
            if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
                scale = 295.5;
            } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
                scale = 347;
            } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH){
                scale = 383;
            }
            self.cameraImageView.width = SCREEN_HEIGHT/(scale/SCREEN_WIDTH);
            self.cameraImageView.height = SCREEN_WIDTH/(scale/SCREEN_WIDTH);
            self.cameraImageView.top = SCREEN_WIDTH - SCREEN_WIDTH/(scale/SCREEN_WIDTH);
            self.cameraImageView.left = SCREEN_HEIGHT - SCREEN_HEIGHT/(scale/SCREEN_WIDTH);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 delay:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
                self.backView.top = -SCREEN_HEIGHT-100;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

//开关手电筒
-(void)turnOnLed:(bool)update
{
    [device lockForConfiguration:nil];
    if (update) {
        [device setTorchMode:AVCaptureTorchModeOn];
        device.flashMode = AVCaptureFlashModeOn;
        [UIView animateWithDuration:0.2 animations:^{
            self.flashButtonImageView.left += 45;
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.flashButtonImageView.left -= 45;
        }];
        [device setTorchMode: AVCaptureTorchModeOff];
        device.flashMode = AVCaptureFlashModeOff;
    }
    [device unlockForConfiguration];
}

- (void)flashButtonClick:(UIBarButtonItem *)sender {
    NSLog(@"flashButtonClick");
    isUsingFlashLight = !isUsingFlashLight;
    
    [self turnOnLed:isUsingFlashLight];
    
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {

        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}


@end
