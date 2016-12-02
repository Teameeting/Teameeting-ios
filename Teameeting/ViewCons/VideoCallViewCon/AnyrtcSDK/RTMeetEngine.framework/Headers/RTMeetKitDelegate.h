//
//  RTMeetKitDelegate.h
//  RTMeetEngine
//
//  Created by EricTao on 16/11/10.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef RTMeetKitDelegate_h
#define RTMeetKitDelegate_h

@protocol RTMeetKitDelegate <NSObject>
@required
/**
 *  RTC service connection callback
 *
 *  @param strAnyrtcId id
 */
- (void)OnRTCJoinMeetOK:(NSString*)strAnyrtcId;
/**
 *  RTC service connection callback
 *
 *  @param strAnyrtcId id
 *  @param code      if 0,scuess
 *  @param strReason reason
 */
- (void)OnRTCJoinMeetFailed:(NSString*)strAnyrtcId withCode:(int)code withReaso:(NSString*)strReason;
/**
 *  RTC server close
 *
 *  @param code      if 0 scuess;other's failure
 */
- (void)OnRTCLeaveMeet:(int) code;
/**
 *  The attachment successfully，after you get this callback,You should do show this video
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID;
/**
 *  Attachment to disconnect，after you get this callback,You should clean up the display
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID;
/**
 *  Attachment to disconnect，after you get this callback,You should clean up the display
 *
 *  @param strLivePeerID other's peer id
 */
- (void)OnRTCAVStatus:(NSString*)strLivePeerID withAudio:(BOOL)audio withVideo:(BOOL)video;

/**
 video view size change

 @param videoView video view
 @param size size
 */
-(void) OnRtcViewChanged:(UIView*)videoView didChangeVideoSize:(CGSize)size;
@end

#endif /* RTMeetKitDelegate_h */
