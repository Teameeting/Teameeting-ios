//
//  VideoShowItem.h
//  Teameeting
//
//  Created by zjq on 16/1/20.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoShowItem : NSObject

@property (nonatomic, strong) UIView *videoView;   // local or remote view
@property (nonatomic, strong) NSString *channelID; // the user channel ID of view
@property (nonatomic) BOOL isBack;                 // the direction of local camera (default is NO) ,if the video is remote ,the parameter is failure (Recommended not to set up)
@property (nonatomic, assign) CGSize videoSize;            // record the video size


- (void)setVideoHidden:(BOOL)isVideoHidden;
- (void)setAudioClose:(BOOL)isAudioClose;

- (void)setFullScreen:(BOOL)isFull;

@end
