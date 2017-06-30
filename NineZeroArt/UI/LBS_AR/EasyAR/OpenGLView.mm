/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import "OpenGLView.h"
#import "AppDelegate.h"
#import "HTUIHeader.h"
#import "SKScanningResultView.h"
#import "NZPScanningFileDownloadManager.h"
#import "SKDownloadProgressView.h"
#import "ClientConfiguration.h"

#include <iostream>
#include "ar.hpp"
#include "renderer.hpp"

/*
* Steps to create the key for this sample:
*  1. login www.easyar.com
*  2. create app with
*      Name: HelloARMultiTarget-MT
*      Bundle ID: cn.easyar.samples.helloarmultitargetmt
*  3. find the created item in the list and show key
*  4. set key string bellow
*/
NSString* key = [[ClientConfiguration sharedInstance] EasyARAppKey];

namespace EasyAR{
    namespace samples{
        class HelloAR : public AR {
        public:
            HelloAR();
            ~HelloAR();
            virtual void initGL(int type, int count);
            virtual void resizeGL(int width, int height);
            virtual bool isRecognizedTarget();
            virtual void render();
            virtual bool clear();
            int flag = 0;
			NSArray *videoURLs;
			id progressDelegate;
			int lastTrackedTargetId;
			
        private:
            Vec2I view_size;
            
            int swipeType;   //0 普通扫一扫, 1 拼图扫一扫
			int targetCount;
            
            VideoRenderer* renderer[40];
            
			int tracked_target;
            int active_target;
            int texid[40];
            ARVideo* video;
            VideoRenderer* video_renderer;
            
            SKScanningResultView *resultView;
        };
        
        HelloAR::HelloAR() {
            tracked_target = 0;
            active_target = 0;
            view_size[0] = -1;
            for(int i = 0; i < 40; ++i) {
                texid[i] = 0;
                renderer[i] = new VideoRenderer;
            }
            video = NULL;
            video_renderer = NULL;
        }
        
        HelloAR::~HelloAR() {
            for(int i = 0; i < targetCount; ++i) {
                delete renderer[i];
            }
        }
        
        void HelloAR::initGL(int type, int count) {
            augmenter_ = Augmenter();
            flag = 0;
            swipeType = type;
            tracked_target = 0;
			lastTrackedTargetId = -1;
            targetCount = count;
            for(int i = 0; i < targetCount; ++i) {
                renderer[i]->init();
                texid[i] = renderer[i]->texId();
            }
        }
        
        void HelloAR::resizeGL(int width, int height) {
            view_size = Vec2I(width, height);
        }
        
        bool HelloAR::isRecognizedTarget() {
            glClearColor(0.f, 0.f, 0.f, 1.f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            Frame frame = augmenter_.newFrame();
            if(view_size[0] > 0){
                int width = view_size[0];
                int height = view_size[1];
                Vec2I size = Vec2I(1, 1);
                if (camera_ && camera_.isOpened())
                    size = camera_.size();
                if(portrait_)
                    std::swap(size[0], size[1]);
                float scaleRatio = std::max((float)width / (float)size[0], (float)height / (float)size[1]);
                Vec2I viewport_size = Vec2I((int)(size[0] * scaleRatio), (int)(size[1] * scaleRatio));
                if(portrait_)
                    viewport_ = Vec4I(0, height - viewport_size[1], viewport_size[0], viewport_size[1]);
                else
                    viewport_ = Vec4I(0, width - height, viewport_size[0], viewport_size[1]);
                if(camera_ && camera_.isOpened())
                    view_size[0] = -1;
            }
            augmenter_.setViewPort(viewport_);
            augmenter_.drawVideoBackground();
            glViewport(viewport_[0], viewport_[1], viewport_[2], viewport_[3]);
            
            AugmentedTarget::Status status = frame.targets()[0].status();
            if(status == AugmentedTarget::kTargetStatusTracked)
                return true;
            else
                return false;
        }
        
        void HelloAR::render() {
            glClearColor(0.f, 0.f, 0.f, 1.f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            Frame frame = augmenter_.newFrame();
            if(view_size[0] > 0){
                int width = view_size[0];
                int height = view_size[1];
                Vec2I size = Vec2I(1, 1);
                if (camera_ && camera_.isOpened())
                    size = camera_.size();
                if(portrait_)
                    std::swap(size[0], size[1]);
                float scaleRatio = std::max((float)width / (float)size[0], (float)height / (float)size[1]);
                Vec2I viewport_size = Vec2I((int)(size[0] * scaleRatio), (int)(size[1] * scaleRatio));
                if(portrait_)
                    viewport_ = Vec4I(0, height - viewport_size[1], viewport_size[0], viewport_size[1]);
                else
                    viewport_ = Vec4I(0, width - height, viewport_size[0], viewport_size[1]);
                if(camera_ && camera_.isOpened())
                    view_size[0] = -1;
            }
            augmenter_.setViewPort(viewport_);
            augmenter_.drawVideoBackground();
            glViewport(viewport_[0], viewport_[1], viewport_[2], viewport_[3]);
            
            //Custom
            ////////////////////////////////START////////////////////////////////
            
            AugmentedTarget::Status status = frame.targets()[0].status();
            if(status == AugmentedTarget::kTargetStatusTracked){
                int tid = frame.targets()[0].target().id();
                if(active_target && active_target != tid) {
                    video->onLost();
                    delete video;
					video = NULL;
					tracked_target = 0;
                    active_target = 0;
					lastTrackedTargetId = -1;
                }
                if (!tracked_target) {
                    if (swipeType == 0 && video == NULL) {
						// 下载视频
						NSString *filePath = [[NSString stringWithUTF8String:frame.targets()[0].target().name()] stringByDeletingLastPathComponent];
                        NSString *targetImageName = [[NSString stringWithUTF8String:frame.targets()[0].target().name()]  lastPathComponent];
                        int index = [[[targetImageName componentsSeparatedByString:@"_"] lastObject] intValue];
						
						lastTrackedTargetId = index;
						
						__block NSString *videoPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"swipeVideo_%d.mp4", index]];
						
						
						if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
							if (texid[index] && video == NULL) {
								video = new ARVideo;
								std::string videoName = videoPath.UTF8String;
								video->openVideoFile(videoName, texid[index]);
								video_renderer = renderer[index];
							}
						} else {
							// 视频不存在，需要下载
							[[NZPScanningFileDownloadManager manager] downloadVideoWithURL:[NSURL URLWithString:[videoURLs objectAtIndex:index]] progress:^(NSProgress *downloadProgress) {
								[((OpenGLView *)progressDelegate) setupProgressView:downloadProgress];
							} destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
								return [NSURL fileURLWithPath:videoPath];
							} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
								if ([filePath.relativePath isEqual:videoPath]) {
									if (texid[index] && video == NULL) {
									video = new ARVideo;
									std::string videoName = filePath.relativePath.UTF8String;
									video->openVideoFile(videoName, texid[index]);
									video_renderer = renderer[index];
									}
								}
								
							}];
						}
					} else if (swipeType == 1) {
                        NSString *targetImageName = [[NSString stringWithUTF8String:frame.targets()[0].target().name()]  lastPathComponent];
                        int index = [[[targetImageName componentsSeparatedByString:@"_"] lastObject] intValue];
						lastTrackedTargetId = index;
					}
                    if (video) {
                        video->onFound();
                        tracked_target = tid;
                        active_target = tid;
                    }
                }

                Matrix44F projectionMatrix = getProjectionGL(camera_.cameraCalibration(), 0.2f, 500.f);
                Matrix44F cameraview = getPoseGL(frame.targets()[0].pose());
                ImageTarget target = frame.targets()[0].target().cast_dynamic<ImageTarget>();
                if(tracked_target) {
                    video->update();
                    video_renderer->render(projectionMatrix, cameraview, target.size());
                }
            } else {
                if (tracked_target) {
                    video->onLost();
                    tracked_target = 0;
                }
            }
            
            ////////////////////////////////END////////////////////////////////
        }
        
        bool HelloAR::clear()
        {
            AR::clear();
            if(video){
                delete video;
                video = NULL;
                tracked_target = 0;
                active_target = 0;
            }
            return true;
        }
        
    }
}




EasyAR::samples::HelloAR ar;

@interface OpenGLView ()
{
    
}

@property(nonatomic, strong) CADisplayLink * displayLink;

@property (strong, nonatomic) AVPlayer      *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem  *playerItem;

@property (nonatomic, assign) SKScanType swipeType;
@property (nonatomic, assign) int targetsCount; //目标图数量
- (void)displayLinkCallback:(CADisplayLink*)displayLink;

@end

@implementation OpenGLView {
	SKDownloadProgressView *_progressView;
}
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame withSwipeType:(SKScanType)type targetsCount:(int)count; {
    _swipeType = type;
    _targetsCount = count;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = frame.size.height = MAX(frame.size.width, frame.size.height);
    self = [super initWithFrame:frame];
    if(self){
        [self setupGL];

        EasyAR::initialize([key UTF8String]);
        ar.initGL(_swipeType, _targetsCount);
    }

    return self;
}

- (void)dealloc
{
    ar.clear();
}

- (void)setupGL
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;

    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context)
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
    if (![EAGLContext setCurrentContext:_context])
        NSLog(@"Failed to set current OpenGL context");

    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);

    int width, height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);

    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
}

- (void)start{
    ar.initCamera();
	
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            if (_swipeType == 0) {
                if ([fileName containsString:@"swipeTargetImage"]) {
                    NSLog(@"FileName: %@", fileName);
                    NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                    ar.loadFromImage([absolutePath UTF8String], 0);
                }
            } else if (_swipeType == 1) {
                if ([fileName containsString:@"lbsTargetImage"]) {
                    NSLog(@"FileName: %@", fileName);
                    NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                    ar.loadFromImage([absolutePath UTF8String], 0);
                }
            }
        }
    }
    
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).active = true;
    ar.start();
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)pause {
	ar.pause();
}

- (void)restart {
	ar.start();
}

- (void)startWithFileName:(NSString *)fileName videoURLs:(NSArray *)videoURLs {
	ar.initCamera();
	ar.videoURLs = videoURLs;
	ar.progressDelegate = self;
	
	// cache目录
	NSURL *cachePath = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
	NSString *imagePath = [cachePath URLByAppendingPathComponent:[[fileName lastPathComponent] stringByDeletingPathExtension]].relativePath;
	NSFileManager *fileManager=[NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:imagePath]) {
		NSArray *childerFiles=[fileManager subpathsAtPath:imagePath];
		childerFiles = [childerFiles sortedArrayUsingComparator:^NSComparisonResult(NSString* _Nonnull obj1, NSString *  _Nonnull obj2) {
			int index1 = [[[obj1 componentsSeparatedByString:@"_"] lastObject] intValue];
			int index2 = [[[obj2 componentsSeparatedByString:@"_"] lastObject] intValue];
			if (index1 < index2) {
				return NSOrderedAscending;
			} else if (index2 == index1) {
				return NSOrderedSame;
			} else {
				return NSOrderedDescending;
			}
		}];
		for (NSString *fileName in childerFiles) {
			NSLog(@"FileName: %@", fileName);
			if([fileName.pathExtension isEqualToString:@"mp4"]){
				continue;
			}
			NSString *absolutePath=[imagePath stringByAppendingPathComponent:fileName];
			ar.loadFromImage([absolutePath UTF8String], 0);
		}
	}
	
	((AppDelegate*)[[UIApplication sharedApplication]delegate]).active = true;
	ar.start();
	
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
	[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stop
{
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).active = false;
    ar.clear();
}

- (void)displayLinkCallback:(CADisplayLink*)displayLink
{
    if (!((AppDelegate*)[[UIApplication sharedApplication]delegate]).active)
        return;
	
	if ([_delegate respondsToSelector:@selector(isRecognizedTarget:targetId:)]) {
		[_delegate isRecognizedTarget:ar.isRecognizedTarget() targetId:ar.lastTrackedTargetId];
	}
	
	if ([_delegate respondsToSelector:@selector(isRecognizedTarget:)]) {
		[_delegate isRecognizedTarget:ar.isRecognizedTarget()];
	}
	
    ar.render();

    (void)displayLink;
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation
{
    BOOL isPortrait = FALSE;
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            isPortrait = TRUE;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isPortrait = FALSE;
            break;
        default:
            break;
    }
    ar.setPortrait(isPortrait);
    ar.resizeGL(frame.size.width, frame.size.height);
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
            EasyAR::setRotationIOS(270);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            EasyAR::setRotationIOS(90);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            EasyAR::setRotationIOS(180);
            break;
        case UIInterfaceOrientationLandscapeRight:
            EasyAR::setRotationIOS(0);
            break;
        default:
            break;
    }
}

- (void)setupProgressView:(NSProgress *) downloadProgress {
	dispatch_async(dispatch_get_main_queue(), ^{
		//进度条
		if(!_progressView) {
			_progressView = [[SKDownloadProgressView alloc] init];
			_progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
			[self addSubview:_progressView];
		}
		[_progressView setProgressViewPercent:downloadProgress.fractionCompleted];
		if(downloadProgress.fractionCompleted == 1.0) {
			[_progressView removeFromSuperview];
			_progressView = nil;
		}
		
	});
}

@end
