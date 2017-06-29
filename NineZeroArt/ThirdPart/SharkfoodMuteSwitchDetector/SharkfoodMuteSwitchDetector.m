//
//  SharkfoodMuteSwitchDetector.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/18.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "SharkfoodMuteSwitchDetector.h"
#import <AudioToolbox/AudioToolbox.h>

/**
 Sound completion proc - this is the real magic, we simply calculate how long it took for the sound to finish playing
 In silent mode, playback will end very fast (but not in zero time)
 */
void SharkfoodSoundMuteNotificationCompletionProc(SystemSoundID  ssID,void* clientData);

@interface SharkfoodMuteSwitchDetector()
/**
 Find out how fast the completion call is called
 */
@property (nonatomic,assign) NSTimeInterval interval;
/**
 Our silent sound (0.5 sec)
 */
@property (nonatomic,assign) SystemSoundID soundId;
/**
 Set to true after the block was set or during init.
 Otherwise the block is called only when the switch value actually changes
 */
@property (nonatomic,assign) BOOL forceEmit;
/**
 Sound completion, objc
 */
-(void)complete;
/**
 Our loop, checks sound switch
 */
-(void)loopCheck;
/**
 Pause while in the background, if your app supports playing audio in the background, you want this.
 Otherwise your app will be rejected.
 */
-(void)didEnterBackground;
/**
 Resume when entering foreground
 */
-(void)willReturnToForeground;
/**
 Schedule a next check
 */
-(void)scheduleCall;
/**
 Is paused?
 */
@property (nonatomic,assign) BOOL isPaused;
/**
 Currently playing? used when returning from the background (if went to background and foreground really quickly)
*/
@property (nonatomic,assign) BOOL isPlaying;

/*First time things are called it's also things nothing is playing,
    So we're not calling anything on the first load
 **/
@property (nonatomic, assign) BOOL isFirst;

@end



void SharkfoodSoundMuteNotificationCompletionProc(SystemSoundID  ssID,void* clientData){
    SharkfoodMuteSwitchDetector* detecotr = (__bridge SharkfoodMuteSwitchDetector*)clientData;
    [detecotr complete];
}


@implementation SharkfoodMuteSwitchDetector

-(id)init{
    self = [super init];
    if (self){
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"mute" withExtension:@"caf"];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_soundId) == kAudioServicesNoError){
            AudioServicesAddSystemSoundCompletion(self.soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, SharkfoodSoundMuteNotificationCompletionProc,(__bridge void *)(self));
            UInt32 yes = 1;
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(_soundId),&_soundId,sizeof(yes), &yes);
            [self performSelector:@selector(loopCheck) withObject:nil afterDelay:1];
            self.forceEmit = YES;
        } else {
            self.soundId = -1;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willReturnToForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

        _isFirst = true;
    }
    return self;
}

-(void)didEnterBackground{
    self.isPaused = YES;
}
-(void)willReturnToForeground{
    self.isPaused = NO;
    if (!self.isPlaying){
        [self scheduleCall];
    }
}

-(void)setSilentNotify:(SharkfoodMuteSwitchDetectorBlock)silentNotify{
    _silentNotify = [silentNotify copy];
    self.forceEmit = YES;
}

+(SharkfoodMuteSwitchDetector*)shared{
    static SharkfoodMuteSwitchDetector* sShared = nil;
    if (!sShared)
        sShared = [SharkfoodMuteSwitchDetector new];
    return sShared;
}

-(void)scheduleCall{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loopCheck) object:nil];
    [self performSelector:@selector(loopCheck) withObject:nil afterDelay:1];
}

-(void)complete{

    self.isPlaying = NO;
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - self.interval;
    BOOL isMute = elapsed < 0.3; // Should have been 0.5 sec, but it seems to return much faster (0.3something)
    if(self.silentNotify) self.silentNotify(isMute);
    if (self.isMute != isMute || self.forceEmit) {
        self.forceEmit = NO;
        _isMute = isMute;
        if (self.silentNotify && !self.isFirst) {
            self.silentNotify(isMute);
        } else {
            self.isFirst = false;
        }
    }
    [self scheduleCall];
}

-(void)loopCheck{
    if (!self.isPaused){
        self.interval = [NSDate timeIntervalSinceReferenceDate];
        self.isPlaying = YES;
        AudioServicesPlaySystemSound(self.soundId);
    }
}


// For reference only, this DTOR will never be invoked.

-(void)dealloc{
    if (self.soundId != -1){
        AudioServicesRemoveSystemSoundCompletion(self.soundId);
        AudioServicesDisposeSystemSoundID(self.soundId);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


#define SAMPLE_RATE 44000
#define SAMPLES 0.2

void MuteSoundPlaybackComplete(SystemSoundID  ssID,void* clientData){

    NSDictionary *soundData = CFBridgingRelease(clientData);
    SKMuteSwitchDetectorBlock andPerform = soundData[@"andPerform"];
    SystemSoundID soundId = [soundData[@"soundId"] unsignedIntValue];

    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - [soundData[@"start"] doubleValue];
    andPerform(YES, elapsed < 0.2);
    
    AudioServicesRemoveSystemSoundCompletion(soundId);
    AudioServicesDisposeSystemSoundID(soundId);
}

BOOL createSoundFileIfRequired(NSString* soundFile) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:soundFile isDirectory:FALSE])
        return YES;
    
    NSUInteger length = SAMPLE_RATE * SAMPLES * 2; // 2 bytes per sample
    NSUInteger temp;
    // initialize with room for RIFF chunk (36) + "data" header from data chunk + actual sound data
    NSMutableData *data = [NSMutableData dataWithCapacity:(length + 36 + 4)];
    
    [data appendData:[@"RIFF" dataUsingEncoding:NSASCIIStringEncoding]];
    temp = length + 36;
    [data appendData:[NSData dataWithBytes:&temp length:4]];
    [data appendData:[@"WAVE" dataUsingEncoding:NSASCIIStringEncoding]];
    [data appendData:[@"fmt " dataUsingEncoding:NSASCIIStringEncoding]];
    temp = 16;
    [data appendData:[NSData dataWithBytes:&temp length:4]];
    temp = 1;
    [data appendData:[NSData dataWithBytes:&temp length:2]];
    [data appendData:[NSData dataWithBytes:&temp length:2]];
    temp = SAMPLE_RATE;
    [data appendData:[NSData dataWithBytes:&temp length:4]];
    temp *= 2;
    [data appendData:[NSData dataWithBytes:&temp length:4]];
    temp = 2;
    [data appendData:[NSData dataWithBytes:&temp length:2]];
    temp = 16;
    [data appendData:[NSData dataWithBytes:&temp length:2]];
    [data appendData:[@"data" dataUsingEncoding:NSASCIIStringEncoding]];
    [data appendData:[NSData dataWithBytes:&length length:4]];
    temp = 0;
    
    NSData *nullByte = [NSData dataWithBytes:&temp length:1];
    
    for (NSUInteger i = 0; i < length; i++)
        [data appendData:nullByte];
    
    return [data writeToFile:soundFile atomically:YES];
}

@implementation SKMuteSwitchDetector

+ (void)checkSwitch:(SKMuteSwitchDetectorBlock)andPerform {
    if (!andPerform) return;

    NSString *soundFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/silence.wav"];
    
    if (!createSoundFileIfRequired(soundFile)) {
        andPerform(NO, NO);
        return;
    }
    
    SystemSoundID soundId;

    if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundId) == kAudioServicesNoError){
        UInt32 yes = 1;
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(soundId),&soundId,sizeof(yes), &yes);
        
        NSDictionary *clientData = @{@"andPerform" : [andPerform copy], @"soundId" : @(soundId), @"start" : @([NSDate timeIntervalSinceReferenceDate])};
        AudioServicesAddSystemSoundCompletion(soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, MuteSoundPlaybackComplete,(void *)CFBridgingRetain(clientData));

        AudioServicesPlaySystemSound(soundId);
    } else {
        andPerform(NO, NO);
    }
}

@end