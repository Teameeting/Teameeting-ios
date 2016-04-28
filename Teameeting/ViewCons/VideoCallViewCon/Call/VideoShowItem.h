//
//  VideoShowItem.h
//  Teameeting
//
//  Created by zjq on 16/1/20.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnyRTCMeetKit.h"

@interface VideoShowItem : AnyRTCVideoItem

//@property (nonatomic,strong) UIView *showVideoView;

//@property (nonatomic, strong) NSString *publishID;

//@property (nonatomic,assign) CGSize videoSize; // reality video Size


- (void)setVideoHidden:(BOOL)isVideoHidden;
- (void)setAudioClose:(BOOL)isAudioClose;

- (void)setFullScreen:(BOOL)isFull;

@end
