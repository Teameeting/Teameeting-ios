//
//  AnyrtcM2Mutlier.h
//  anyrtc
//
//  Created by EricTao on 15/12/21.
//  Copyright © 2015年 EricTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnyRTC.h"

@protocol AnyRTCMeetDelegate <NSObject>
@optional
/**
 *  Enter metting secuess
 *
 *  @param strAnyrtcId AnyRTC的ID
 */
- (void) OnRtcJoinMeetOK:(NSString*) strAnyrtcId;

/**
 *  Enter metting failed
 *
 *  @param strAnyrtcId AnyRTC的ID
 *  @param code        error code
 *  @param strReason   The reason for the error
 */
- (void) OnRtcJoinMeetFailed:(NSString*) strAnyrtcId withCode:(AnyRTCErrorCode)code withReason:(NSString*) strReason;

/**
 *  Leave meeting
 *
 *  @param code if code is zero is leave meeting scuess,other abnormal or failure
 */
- (void) OnRtcLeaveMeet:(int) code;

/**
 *  Video  window size
 *
 *  @param videoView Video view
 *  @param size      the size of video view
 */
- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size;

/**
 *  The remote view into the meeting
 *
 *  @param channelID  channel id
 *  @param removeView the remote view
 */
- (void) OnRtcOpenRemoteView:(NSString*)channelID  withRemoteView:(UIView *)removeView;

/**
 *  The remote view leave the meeting
 *
 *  @param channelID channel id
 */
- (void)OnRtcRemoveRemoteView:(NSString*)channelID;

/**
 *  State of the remote video audio and video
 *
 *  @param channelID   channel id
 *  @param audioEnable if the audioEnable is ture/false,the remote audio is close/open
 *  @param videoEnable if the videoEnable is ture/false,the remote video is close/open
 */
- (void)OnRtcRemoteAVStatus:(NSString*)channelID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable;
@end


@interface AnyRTCMeetKit : NSObject {
    
}

/**
 *  Initializes the AnyRTCMeetKit object.
 *
 *  @param delegate      delegate
 *  @param localViewItem local video view parameter
 *
 *  @return an object of AnyRTCMeetKit class
 */
- (instancetype)initWithDelegate:(id<AnyRTCMeetDelegate>)delegate
               withLocalViewItem:(AnyRTCVideoItem *)localViewItem;

/**
 *  Join meeting
 *
 *  @param strAnyrtcId meeting id
 *
 *  @return enter meeting scuess or failure
 */
- (BOOL) Join:(NSString*)strAnyrtcId;

/**
 *  Leave meeting ,when you call this method,this class will be dealloc
 */
- (void) Leave;

/**
 *  SetLocalAudioEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetLocalAudioEnable:(BOOL)enable;

/**
 *  SetLocalVideoEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetLocalVideoEnable:(BOOL)enable;

/**
 *  SetSpeakerEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetSpeakerEnable:(BOOL)enable;

/**
 *  SetproximityMonitoringEnabled  (default is NO)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetproximityMonitoringEnabled:(BOOL)enable;

/**
 *  SwitchCamera  font/back local camera
 */
- (void) SwitchCamera;

@end