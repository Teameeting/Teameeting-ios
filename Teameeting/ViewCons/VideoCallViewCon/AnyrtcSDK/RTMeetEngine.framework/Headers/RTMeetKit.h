//
//  RTMeetKit.h
//  RTMeetEngine
//
//  Created by EricTao on 16/11/10.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMeetKit_h
#define RTMeetKit_h

#import <UIKit/UIKit.h>
#import "RTMeetKitDelegate.h"

@interface RTMeetKit : NSObject {
    
}
/**
 *  RTC Delegate(if you want add Even wheat function，you should set it)
 */
@property (weak, nonatomic) id<RTMeetKitDelegate> rtc_delegate;
/**
 *  Initialize the hoster clent
 *
 *  @param delegate RTMPCHosterRtmpDelegate
 *  @param capturePosition  camera position
 *
 *  @return hoster object
 */
- (instancetype)initWithDelegate:(id<RTMeetKitDelegate>)delegate;

/**
 Init Meet Engine

 @param strDeveloperId  the developer ID of AnyRTC on the platform
 @param strAppId        the user's app Name on the platform
 @param strAppKey       the user's app key on the platform
 @param strAppToken     the user's app token on the platform
 */
- (void)InitEngineWithAnyrtcInfo:(NSString*)strDeveloperId andAppID:(NSString*)strAppId andAppKey:(NSString*)strAppKey andAppToken:(NSString*)strAppToken;

/**
 Config private server

 @param strAddr  address
 @param nPort    port
 */
- (void)ConfigServerForPriCloud:(NSString*)strAddr andPort:(int)nPort;

#pragma mark Common function
/**
 *  audio setting (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void)SetAudioEnable:(bool) enabled;
/**
 *  video setting (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void)SetVideoEnable:(bool) enabled;
/**
 *  video view show and setting
 *
 *  @param render video view
 *  @param front  camera front or back  if yes front or back
 */
- (void)SetVideoCapturer:(UIView*) render andUseFront:(bool)front;
/**
 *  change camera front or back
 */
- (void)SwitchCamera;
/**
 set camera torchMode
 
 @param isOn open or close torch
 
 @return scuess or failed
 */
- (BOOL)SetCameraTorchMode:(bool)isOn;

#pragma mark RTC function for line
/**
 *  Open RTC function
 *
 *  @param strAnyrtcID the anyrtc of id
 *  @param strCustomID host's user id (this id is you platform's id)
 *  @param strUserData if you want other know you platform's information，you can add it
 *
 *  @return scuess or failed
 */
- (BOOL)Join:(NSString*)strAnyrtcID;
/**
 *  Host hung up other's video(close line)
 *
 *  @param
 */
- (void)Leave;
/**
 *  Show other's video (if you again other's request line,you will get callback,then set it)；if device landscape mode,render's size 4:3;if device portrait mode,render's size 3:4
 *
 *  @param strLivePeerID peer id
 *  @param render        video view
 */
- (void)SetRTCVideoRender:(NSString*)strLivePeerID andRender:(UIView*)render;
@end

#endif /* RTMeetKit_h */
