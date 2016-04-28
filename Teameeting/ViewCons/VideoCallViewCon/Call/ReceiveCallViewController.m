//
//  CallOtherViewController.m
//  DropevaDevice
//
//  Created by zjq on 15/10/10.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "ReceiveCallViewController.h"
#import "AnyRTCMeetKit.h"

#import <AVFoundation/AVFoundation.h>
#import "ASHUD.h"
#import "TMMessageManage.h"
#import "VideoShowItem.h"
#import "ToolUtils.h"

#define bottonSpace 10
#define VideoWidth 100
@interface ReceiveCallViewController ()<AnyRTCMeetDelegate,UIGestureRecognizerDelegate,tmMessageReceive>
{
    VideoShowItem *_localVideoItem;
    
    CGSize _localVideoSize;
    
    NSString *_peerSelectedId;
    NSString *_peerOldSelectedId;
    
    // VIEW
    BOOL videoOldEnable;
    
    BOOL isRightTran;
    
    BOOL isChat;
    
}
@property (nonatomic, strong) NSMutableDictionary *_dicRemoteVideoView;
@property (nonatomic, strong) NSMutableDictionary *_audioOperateDict;
@property (nonatomic, strong) NSMutableDictionary *_videoOperateDict;
@property (nonatomic, strong) NSMutableArray *_userArray;
@property (nonatomic, strong) NSMutableArray *_channelArray;

@property(nonatomic, strong) AnyRTCMeetKit *_client;
@property(nonatomic, strong) UIScrollView *videosScrollView;
@property(nonatomic, assign) BOOL isFullScreen;

@end

@implementation ReceiveCallViewController

@synthesize _dicRemoteVideoView;

@synthesize _client;
@synthesize roomItem;
@synthesize _userArray,_channelArray,_audioOperateDict,_videoOperateDict;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FULLSCREEN" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TALKCHAT_NOTIFICATION" object:nil];

    if (_dicRemoteVideoView) {
        _dicRemoteVideoView = nil;
    }

    if (_client) {
        _client  = nil;
    }
}

- (id)init {
    
    if (self = [super init]) {
        isRightTran = NO;
        [[TMMessageManage sharedManager] registerMessageListener:self];
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.videosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100 - VideoParViewHeight, self.view.bounds.size.width, VideoParViewHeight)];
    self.videosScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.videosScrollView.bounces = YES;
    self.videosScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.videosScrollView setUserInteractionEnabled:YES];
    [self.videosScrollView setHidden:NO];
    self.videosScrollView.alwaysBounceVertical = NO;
//    [self.videosScrollView setScrollEnabled:NO];
    self.videosScrollView.backgroundColor = [UIColor clearColor];
    _peerSelectedId = nil;
    _userArray = [[NSMutableArray alloc] initWithCapacity:5];
    _channelArray = [[NSMutableArray alloc] initWithCapacity:5];
    _videoOperateDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    _audioOperateDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    _dicRemoteVideoView = [[NSMutableDictionary alloc] initWithCapacity:5];
   
    

    _localVideoItem = [[VideoShowItem alloc] init];
    [_localVideoItem setFullScreen:NO];
    UIView *local = [[UIView alloc] initWithFrame:self.view.frame];
    _localVideoItem.videoView = local;
    
    _client = [[AnyRTCMeetKit alloc] initWithDelegate:self withLocalViewItem:_localVideoItem];
   
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locolvideoSingleTap:)];
    singleTapGestureRecognizer.delegate = self;
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [_localVideoItem.videoView addGestureRecognizer:singleTapGestureRecognizer];
    [self.view addSubview:_localVideoItem.videoView];
 
    
    [self.view addSubview:self.videosScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullSreenNoti:) name:@"FULLSCREEN" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatViewNoti:) name:@"TALKCHAT_NOTIFICATION" object:nil];

     [_client Join:roomItem.anyRtcID];

    videoOldEnable = NO;
    
}

// setting pre operate to view
- (void)settingMediaToViewOperate:(VideoShowItem*)item
{
    NSNumber *audio = [_audioOperateDict objectForKey:item.channelID];
    NSNumber *video = [_videoOperateDict objectForKey:item.channelID];
    
    if (audio) {
        if (![audio boolValue]) {
            [item setAudioClose:YES];
        }else{
            [item setAudioClose:NO];
        }
        [_audioOperateDict removeObjectForKey:item.channelID];
    }
    if (video) {
        if (![video boolValue]) {
            [item setVideoHidden:YES];
        }else{
            [item setVideoHidden:NO];
        }
        [_videoOperateDict removeObjectForKey:item.channelID];
    }
}

-(BOOL)receiveMessageEnable {
    
    return YES;
}

// ios iphone notification
- (void)chatViewNoti:(NSNotification*)noti
{
    isChat = [noti.object boolValue];
    if (isChat) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x, self.view.bounds.size.height - VideoParViewHeight, self.view.bounds.size.width, VideoParViewHeight);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
            self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x, self.view.bounds.size.height - 100 - VideoParViewHeight, self.view.bounds.size.width, VideoParViewHeight);
        }];
    }
}

- (void)fullSreenNoti:(NSNotification *)noti {
    
    self.isFullScreen = !self.isFullScreen;
    [self layoutSubView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    Class class = NSClassFromString(@"GLKView");
    if ([touch.view isKindOfClass:class] && CGRectGetWidth(touch.view.frame) < self.view.bounds.size.width){
        
        return YES;
        
    }
    return NO;
}

#pragma mark - publish method
- (void)videoEnable:(BOOL)enable
{
    if (!enable) {
        videoOldEnable = YES;
    }else{
        videoOldEnable = NO;
    }
    if (_client) {
         [_client SetLocalVideoEnable:enable];
       
        if (enable) {
            [_localVideoItem setVideoHidden:NO];
        }else{
            [_localVideoItem setVideoHidden:YES];
        }
    }
}
- (void)audioEnable:(BOOL)enable
{
    if (_client) {
        [_client SetLocalAudioEnable:enable];
        if (enable) {
            [_localVideoItem setAudioClose:NO];
        }else{
             [_localVideoItem setAudioClose:YES];
        }
    }
}

- (void)switchCamera // switch camera
{
    if (_client) {
        [_client SwitchCamera];
    }
}
- (void)hangeUp      // hunge up
{
    if (_client) {
         [_client Leave];
        [[TMMessageManage sharedManager] tmRoomCmd:MCMeetCmdLEAVE roomid:self.roomItem.roomID withRoomName:self.roomItem.roomName remain:@""];
        [[TMMessageManage sharedManager] removeMessageListener:self];
    }
}
- (void)sendMessageWithCmmand:(NSString *)cmd userID:(NSString *)userid {
    
}

- (void)transitionVideoView:(BOOL)isRigth
{
    if (isRigth) {
        isRightTran = YES;
        [UIView animateWithDuration:.2 animations:^{
            self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x+TalkPannelWidth, self.videosScrollView.frame.origin.y, self.videosScrollView.frame.size.width-TalkPannelWidth, VideoParViewHeight);
             self.videosScrollView.contentOffset = CGPointMake(0, 0);
            [self layoutSubView];
        }completion:^(BOOL finished) {
//           [self layoutSubView];
        }];
    }else{
        isRightTran = NO;
        [UIView animateWithDuration:.2 animations:^{
            self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x-TalkPannelWidth, self.videosScrollView.frame.origin.y, self.videosScrollView.frame.size.width+TalkPannelWidth, VideoParViewHeight);
             self.videosScrollView.contentOffset = CGPointZero;
            [self layoutSubView];
        }completion:^(BOOL finished) {
//            [self layoutSubView];
        }];
    }
   
}


#pragma mark - notification
// 程序进入后台时，停止视频
- (void)applicationWillResignActive
{
    if (!videoOldEnable) {
        [_client SetLocalVideoEnable:NO];
    }
}

// 程序进入前台时，重启视频
- (void)applicationDidBecomeActive
{
    if (!videoOldEnable) {
        [_client SetLocalVideoEnable:YES];
    }
    [self layoutSubView];
}

- (void)layoutSubView
{
    if ([ToolUtils shead].isBack) {
        return;
    }
    [ASHUD hideHUD];
    if (self.isFullScreen) {
        [UIView animateWithDuration:.2 animations:^{
            if (isRightTran) {
                self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x, self.view.bounds.size.height - VideoParViewHeight, self.view.bounds.size.width-TalkPannelWidth, VideoParViewHeight);
            }else{
                self.videosScrollView.frame = CGRectMake(0, self.view.bounds.size.height - VideoParViewHeight, self.view.bounds.size.width, VideoParViewHeight);
            }
        }];
        if (_peerSelectedId) {
            VideoShowItem *item = [_dicRemoteVideoView objectForKey:_peerSelectedId];
            [item setFullScreen:YES];
            if (_peerOldSelectedId) {
                VideoShowItem *item = [_dicRemoteVideoView objectForKey:_peerOldSelectedId];
                [item setFullScreen:YES];
            }else{
                [_localVideoItem setFullScreen:YES];
            }
        }else{
              [_localVideoItem setFullScreen:YES];
            if (_peerOldSelectedId) {
                VideoShowItem *item = [_dicRemoteVideoView objectForKey:_peerOldSelectedId];
                [item setFullScreen:YES];
            }
        }
        
    }else {
        [UIView animateWithDuration:.2 animations:^{
            if (isRightTran) {
                self.videosScrollView.frame = CGRectMake(self.videosScrollView.frame.origin.x, self.view.bounds.size.height - 100 - VideoParViewHeight, self.view.bounds.size.width-TalkPannelWidth, VideoParViewHeight);
            }else{
                if (!isChat) {
                     self.videosScrollView.frame = CGRectMake(0, self.view.bounds.size.height - 100 - VideoParViewHeight, self.view.bounds.size.width, VideoParViewHeight);
                }
               
            }
        }];
        if (_peerSelectedId) {
            VideoShowItem *item = [_dicRemoteVideoView objectForKey:_peerSelectedId];
            [item setFullScreen:NO];
        }else{
             [_localVideoItem setFullScreen:NO];
        }
        if (_peerOldSelectedId) {
            VideoShowItem *item = [_dicRemoteVideoView objectForKey:_peerOldSelectedId];
            [item setFullScreen:YES];
        }
    }
    
    if (_peerSelectedId) {
        [_localVideoItem setFullScreen:YES];
        
        VideoShowItem* view = nil;
        view = (VideoShowItem*)[_dicRemoteVideoView objectForKey:_peerSelectedId];

        if (view.videoSize.width>0&& view.videoSize.height>0) {
             //Aspect fit local video view into a square box.
            CGRect remoteVideoFrame =
            AVMakeRectWithAspectRatioInsideRect(view.videoSize, self.view.bounds);
            CGFloat scale = 1;
            if (remoteVideoFrame.size.width < remoteVideoFrame.size.height) {
                // Scale by height.
                scale = self.view.bounds.size.height / remoteVideoFrame.size.height;
            } else {
                // Scale by width.
                scale = self.view.bounds.size.width / remoteVideoFrame.size.width;
            }
            remoteVideoFrame.size.height *= scale;
            remoteVideoFrame.size.width *= scale;
            view.videoView.frame = remoteVideoFrame;
            view.videoView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
            
        }else{
            view.videoView.frame = self.view.bounds;
            view.videoView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
        }
        if ([view.videoView.superview isKindOfClass:[self.videosScrollView class]]) {
            [view.videoView removeFromSuperview];
            [self.view addSubview:view.videoView];
            [self.view sendSubviewToBack:view.videoView];
        }else if([view.videoView.superview isKindOfClass:[self.view class]]){
             [self.view sendSubviewToBack:view.videoView];
        }else{
            [self.view addSubview:view.videoView];
            [self.view sendSubviewToBack:view.videoView];
        }
        
        [self.videosScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        float sizeViewAllWidth = 0;

        if ([_localVideoItem.videoView.superview isKindOfClass:[self.view class]]) {
            [_localVideoItem.videoView removeFromSuperview];
        }
        
        CGFloat videoViewHeight = 0.0;
        if (ISIPAD) {
            videoViewHeight = self.view.bounds.size.height/4.5;
        }else{
            videoViewHeight = self.view.bounds.size.height/4;
        }
        CGFloat localViewWidth = 0.0;
        CGFloat remoteViewWidth = 0.0;

        float scaleHeight = [self getAllWidthWithHeight:videoViewHeight withAllHeight:&sizeViewAllWidth withLocal:YES];
        videoViewHeight = scaleHeight;
        if (_localVideoSize.width>0 && _localVideoSize.height>0) {
            localViewWidth = (_localVideoSize.width/_localVideoSize.height)*videoViewHeight;
        }else{
            localViewWidth = VideoWidth;
        }
        
        CGFloat x = (self.videosScrollView.bounds.size.width - (sizeViewAllWidth))/2;
      
        CGFloat y = self.videosScrollView.bounds.size.height - videoViewHeight;
        
        for (id key in [_dicRemoteVideoView allKeys]) {
            if (![key isEqualToString:_peerSelectedId]) {
                VideoShowItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
                if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
                   remoteViewWidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*videoViewHeight;
                   viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    [self.videosScrollView addSubview:viewsmail.videoView];
                    x = x+remoteViewWidth;
                }else{
                    remoteViewWidth = VideoWidth;
                    viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    [self.videosScrollView addSubview:viewsmail.videoView];
                    x = x+remoteViewWidth;
                }
            }
        }
        _localVideoItem.videoView.frame = CGRectMake(x, y, localViewWidth, videoViewHeight);
        [self.videosScrollView addSubview:_localVideoItem.videoView];
  
    } else {
        
        if (_dicRemoteVideoView.count==0) {
            if (_localVideoSize.width && _localVideoSize.height > 0) {
                float scaleW = self.view.bounds.size.width/_localVideoSize.width;
                float scaleH = self.view.bounds.size.height/_localVideoSize.height;
                if (scaleW>scaleH) {
                    _localVideoItem.videoView.frame = CGRectMake(0, 0, _localVideoSize.width*scaleW, _localVideoSize.height*scaleW);
                    _localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
                }else{
                    _localVideoItem.videoView.frame = CGRectMake(0, 0, _localVideoSize.width*scaleH, _localVideoSize.height*scaleH);
                    _localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
                }
                
            } else {
                _localVideoItem.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            }
            [_localVideoItem.videoView removeFromSuperview];
            [self.view addSubview:_localVideoItem.videoView];
            [self.view sendSubviewToBack:_localVideoItem.videoView];
            return;
        }
        if (_localVideoSize.width && _localVideoSize.height > 0) {
            float scaleW = self.view.bounds.size.width/_localVideoSize.width;
            float scaleH = self.view.bounds.size.height/_localVideoSize.height;
            if (scaleW>scaleH) {
                _localVideoItem.videoView.frame = CGRectMake(0, 0, _localVideoSize.width*scaleW, _localVideoSize.height*scaleW);
                _localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
            }else{
                _localVideoItem.videoView.frame = CGRectMake(0, 0, _localVideoSize.width*scaleH, _localVideoSize.height*scaleH);
                _localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
            }
        } else {
            _localVideoItem.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        [_localVideoItem.videoView removeFromSuperview];
        [self.view addSubview:_localVideoItem.videoView];
        [self.view sendSubviewToBack:_localVideoItem.videoView];
    
        
        float sizeViewAllWidth = 0;
        CGFloat videoViewHeight = 0.0;
        if (ISIPAD) {
            videoViewHeight = self.view.bounds.size.height/4.5;
        }else{
            videoViewHeight = self.view.bounds.size.height/4;
        }
        CGFloat remoteViewWidth = 0.0;
        
        float scaleHeight = [self getAllWidthWithHeight:videoViewHeight withAllHeight:&sizeViewAllWidth withLocal:NO];
        videoViewHeight = scaleHeight;
        
        CGFloat x = (self.videosScrollView.bounds.size.width - sizeViewAllWidth)/2;
     
        CGFloat y = self.videosScrollView.bounds.size.height - videoViewHeight;
        
        for (id key in [_dicRemoteVideoView allKeys]) {
            if (![key isEqualToString:_peerSelectedId]) {
                VideoShowItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
                if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
                    remoteViewWidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*videoViewHeight;
                    viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    [self.videosScrollView addSubview:viewsmail.videoView];
                    x = x+remoteViewWidth;
                }else{
                    remoteViewWidth = VideoWidth;
                    viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    [self.videosScrollView addSubview:viewsmail.videoView];
                    x = x+remoteViewWidth;
                }
            }
        }
    }
}
- (float)getAllWidthWithHeight:(float)height withAllHeight:(float*)allWidth withLocal:(BOOL)hasLocal{
    float width = 0.0f;
    float videowidth = 0.0f;
    for (id key in [_dicRemoteVideoView allKeys]) {
        if (![key isEqualToString:_peerSelectedId]) {
            VideoShowItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
            if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
               videowidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*height;
            }else{
                videowidth = VideoWidth;
            }
            viewsmail.videoView.frame = CGRectMake(0,0, videowidth, height);
            width += videowidth;
        }
    }
    float localWidth = 0.0;
    if (hasLocal) {
        if (_localVideoSize.width>0 && _localVideoSize.height>0) {
            localWidth = (_localVideoSize.width/_localVideoSize.height)*height;
        }else{
            localWidth = VideoWidth;
        }
    }
  
    *allWidth = width+localWidth;
    
    if ((width + localWidth)>self.videosScrollView.bounds.size.width) {
        height-=20;
        return [self getAllWidthWithHeight:height withAllHeight:allWidth withLocal:hasLocal];
    }
    return height;
}

#pragma mark -  UITapGestureRecognizer
- (void)locolvideoSingleTap:(UITapGestureRecognizer*)gesture
{
    if (_peerSelectedId) {
        _peerOldSelectedId = _peerSelectedId;
        _peerSelectedId = nil;
        [self layoutSubView];
    }
   
}
- (void)singleTap:(UITapGestureRecognizer*)gesture
{
    // 像变大(先看是不是点中的)
    UIView  *view = (UIView*)[gesture view];
    // 如果得到的是小图的，变为大图
    if (CGRectGetHeight(view.frame) < self.view.bounds.size.height/2) {
        for (id key in [_dicRemoteVideoView allKeys]) {
            VideoShowItem *item = [_dicRemoteVideoView objectForKey:key];
         
            if (item.videoView == view) {
                _peerOldSelectedId = _peerSelectedId;
                _peerSelectedId = key;
                [self layoutSubView];
                return;
            }
        }
    }else{
        if (self.videoController) {
            [self.videoController tapEvent:nil];
        }
    }
}
#pragma mark -  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - AnyrtcM2MDelegate


/** 进会成功
 * @param strAnyrtcId	AnyRTC的ID
 */
- (void) OnRtcJoinMeetOK:(NSString*) strAnyrtcId
{
    NSLog(@"OnRtcJoinMeetOK:%@",strAnyrtcId);
}

/** 进会失败
 * @param strAnyrtcId	AnyRTC的ID
 * @param code	错误代码
 * @param strReason		原因
 */
- (void) OnRtcJoinMeetFailed:(NSString*) strAnyrtcId withCode:(AnyRTCErrorCode) code withReason:(NSString*) strReason
{
    NSLog(@"OnRtcJoinMeetFailed:%@ withCode:%ld withReason:%@",strAnyrtcId,(long)code,strReason);
}

/** 离开会议
 *
 */
- (void) OnRtcLeaveMeet:(int) code
{
     NSLog(@"OnRtcLeaveMeet:%d",code);
    if (code == AnyRTC_FORCE_EXIT)
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"强制退出" icon:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });

   
}

- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size {
    NSLog(@"-------%d",[NSThread isMainThread]);
    if (videoView == _localVideoItem.videoView) {
        _localVideoItem.videoSize = size;
        _localVideoSize = size;
    }else{
        NSLog(@"didChangeVideoSize:%f  %f",size.width,size.height);
        for (NSString *strTag in [_dicRemoteVideoView allKeys]) {
           VideoShowItem *remoteView = (VideoShowItem*)[_dicRemoteVideoView objectForKey:strTag];
            if (remoteView.videoView == videoView) {
                remoteView.videoSize = size;
                // setting
                [self settingMediaToViewOperate:remoteView];
                break;
            }
        }
        NSLog(@"OnRtcVideoView:%f %f",size.width,size.height);
    }
    [self layoutSubView];
    
}
/*! @brief 远程图像进入p2p会议
 *
 *  @param removeView 远程图像
 *  @param peerChannelID  该通道标识符
 */
- (void) OnRtcOpenRemoteView:(NSString*)channelID  withRemoteView:(UIView *)removeView
{
   
    VideoShowItem* findView = [_dicRemoteVideoView objectForKey:channelID];
    if (findView.videoView == removeView) {
        return;
    }
    if (!_peerSelectedId&&_dicRemoteVideoView.count==0) {
        _peerSelectedId = channelID;
    }
    
    VideoShowItem *item = [[VideoShowItem alloc] init];
    item.videoView = removeView;
    item.channelID = channelID;
    
    [_dicRemoteVideoView setObject:item forKey:channelID];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    singleTapGestureRecognizer.delegate = self;
    [item.videoView  addGestureRecognizer:singleTapGestureRecognizer];

    
    [self layoutSubView];
    //While the number of remote image change, send a notification
    NSNumber *remoteVideoCount = [NSNumber numberWithInteger:[_dicRemoteVideoView count]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOTEVIDEOCHANGE" object:remoteVideoCount];

   
    
}

/*! @brief 远程图像离开会议
 *
 *  @param publishID  该通道标识符
 */
- (void)OnRtcRemoveRemoteView:(NSString*)channelID
{
    
    VideoShowItem *findView = [_dicRemoteVideoView objectForKey:channelID];
    if (findView) {
        if ([channelID isEqualToString:_peerSelectedId]) {
            [findView.videoView removeFromSuperview];
            [_dicRemoteVideoView removeObjectForKey:channelID];
            if (_dicRemoteVideoView.count!=0) {
                _peerSelectedId =[[_dicRemoteVideoView allKeys] firstObject];
            }else{
                _peerSelectedId = nil;
            }
        }else{
            [findView.videoView removeFromSuperview];
            [_dicRemoteVideoView removeObjectForKey:channelID];
           
        }
        if (_dicRemoteVideoView.count ==0) {
            self.isFullScreen = NO;
        }
        [self layoutSubView];
    }
   
    //While the number of remote image change, send a notification
    NSNumber *remoteVideoCount = [NSNumber numberWithInteger:[_dicRemoteVideoView count]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOTEVIDEOCHANGE" object:remoteVideoCount];
    
}
/*! @brief 远程视频的音视频状态
 *
 *  @param publishID 通道的ID
 *  @param audioEnable  音频是否开启
 *  @param videoEnable  视频是否开启
 */
- (void)OnRtcRemoteAVStatus:(NSString*)publishID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable
{
    
    VideoShowItem *item = [_dicRemoteVideoView objectForKey:publishID];
    if (item) {
        if (audioEnable) {
            [item setAudioClose:NO];
        }else{
            [item setAudioClose:YES];
        }
        if (videoEnable) {
            [item setVideoHidden:NO];
        }else{
            [item setVideoHidden:YES];
        }
    }else{
        if (!audioEnable) {
            [_audioOperateDict setObject:[NSNumber numberWithBool:audioEnable] forKey:publishID];
        }
        
        if (!videoEnable) {
            [_videoOperateDict setObject:[NSNumber numberWithBool:videoEnable] forKey:publishID];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
