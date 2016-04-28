//
//  AudioManager.m
//  Teameeting
//
//  Created by jianqiangzhang on 16/2/29.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "AudioManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioManager()
{
    BOOL isSpeaker;
}
@end

@implementation AudioManager

- (void)closeProximityMonitorEnable;
{
   [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
}
- (id)init
{
    self = [super init];
    if (self) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *audioSessionError;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError];
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
    }
    return self;
}
- (void)setSpeakerOn
{
    if (!isSpeaker) {
        if (!ISIPAD) {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
        
        isSpeaker = YES;
    }
   
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


@end
