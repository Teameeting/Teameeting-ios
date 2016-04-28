//
//  VideoShowItem.m
//  Teameeting
//
//  Created by zjq on 16/1/20.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "VideoShowItem.h"
@interface VideoShowItem()
@property (nonatomic, strong) UIImageView *micImageView;
@property (nonatomic, strong) UIImageView *videoHiddenView;
@property (nonatomic, strong) UIImageView *videoHiddenImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSLayoutConstraint * constraintTop;
@property (nonatomic, strong) NSLayoutConstraint * constraintRight;
@property (nonatomic, strong) NSLayoutConstraint * constraintWidth;
@property (nonatomic, strong) NSLayoutConstraint * constraintHeight;
@property (nonatomic, assign) BOOL isHiddenMic;
@property (nonatomic, assign) BOOL isHiddenVideo;
@property (nonatomic, assign) BOOL isFull;
@end
@implementation VideoShowItem
@synthesize micImageView = _micImageView;
@synthesize videoHiddenView = _videoHiddenView;
@synthesize videoHiddenImageView = _videoHiddenImageView;
@synthesize videoSize = _videoSize;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize videoView = _videoView;
- (id)init
{
    self = [super init];
    if (self) {
        self.isFull = YES;
    }
    return self;
}
- (void)dealloc
{
//    if (_showVideoView) {
//        [_showVideoView removeObserver:self forKeyPath:@"frame" context:nil];
//    }
}
- (void)setVideoSize:(CGSize)videoSize
{
    _videoSize = videoSize;
    if (CGSizeEqualToSize(videoSize, CGSizeZero)) {
        if (_activityIndicatorView) {
            [_activityIndicatorView startAnimating];
        }
    }else{
        if (_activityIndicatorView) {
            [_activityIndicatorView stopAnimating];
        }
    }
}
- (void)setVideoView:(UIView *)view
{
    _videoView = view;
    //[_showVideoView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.videoHiddenView = [UIImageView new];
    self.videoHiddenView.backgroundColor = [UIColor grayColor];
    [self.videoView addSubview:self.videoHiddenView];
    _videoHiddenView.hidden = YES;
    
    self.videoHiddenImageView = [UIImageView new];
    self.videoHiddenImageView.backgroundColor = [UIColor clearColor];
    self.videoHiddenImageView.image = [UIImage imageNamed:@"no_video_show"];
    [_videoHiddenView addSubview:self.videoHiddenImageView];
    
    self.micImageView = [UIImageView new];
    self.micImageView.backgroundColor = [UIColor clearColor];
    self.micImageView.image = [UIImage imageNamed:@"micState"];
    [self.videoView addSubview:self.micImageView];
    self.micImageView.hidden = YES;
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicatorView startAnimating];
    [self.videoView addSubview:self.activityIndicatorView];
    
    
    self.videoHiddenView.translatesAutoresizingMaskIntoConstraints = NO;
    self.micImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoHiddenImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * consv = [NSLayoutConstraint constraintWithItem:_videoHiddenView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * consv1 = [NSLayoutConstraint constraintWithItem:_videoHiddenView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * consv2 = [NSLayoutConstraint constraintWithItem:_videoHiddenView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * consv3 = [NSLayoutConstraint constraintWithItem:_videoHiddenView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    
    NSLayoutConstraint * cons = [NSLayoutConstraint constraintWithItem:_videoHiddenImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_videoHiddenView attribute:NSLayoutAttributeWidth multiplier:0.3f constant:0.0f];
    
    NSLayoutConstraint * cons1 = [NSLayoutConstraint constraintWithItem:_videoHiddenImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_videoHiddenView attribute:NSLayoutAttributeWidth multiplier:0.3f constant:0.0f];
    
    NSLayoutConstraint * cons2 = [NSLayoutConstraint constraintWithItem:_videoHiddenImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_videoHiddenView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * cons3 = [NSLayoutConstraint constraintWithItem:_videoHiddenImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_videoHiddenView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * consAV1 = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * consAV2 = [NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    // mic
    self.constraintHeight = [NSLayoutConstraint constraintWithItem:_micImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    self.constraintWidth = [NSLayoutConstraint constraintWithItem:_micImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    self.constraintTop = [NSLayoutConstraint constraintWithItem:_micImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    self.constraintRight = [NSLayoutConstraint constraintWithItem:_micImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.videoView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0];
    
    [self.videoView addConstraint:consv];
    [self.videoView addConstraint:consv1];
    [self.videoView addConstraint:consv2];
    [self.videoView addConstraint:consv3];
    
    [_videoHiddenView addConstraint:cons];
    [_videoHiddenView addConstraint:cons1];
    [_videoHiddenView addConstraint:cons2];
    [_videoHiddenView addConstraint:cons3];
    
    
    [self.videoView addConstraint:self.constraintWidth];
    [self.videoView addConstraint:self.constraintHeight];
    [self.videoView addConstraint:self.constraintTop];
    [self.videoView addConstraint:self.constraintRight];
    
    [self.videoView addConstraint:consAV1];
    [self.videoView addConstraint:consAV2];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    return;
     if ([keyPath isEqualToString:@"frame"]){
         if (self.videoView) {
             if (self.videoView.frame.size.width>[UIScreen mainScreen].bounds.size.width) {
                 [self.constraintRight setConstant:([UIScreen mainScreen].bounds.size.width-self.videoView.frame.size.width)/2];
             }else{
                 [self.constraintRight setConstant:0.0f];
             }
             if (self.isFull) {
                 
                 if (round(self.videoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
                     [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2];
                 }else{
                     [self.constraintTop setConstant:[UIScreen mainScreen].bounds.size.height -self.videoView.frame.size.height];
                 }
             }else{
                 
                 if (round(self.videoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
                     if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                         if (ISIPAD) {
                             [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+64];
                         }else{
                             [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+44];
                         }
                         
                     }else{
                         [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+64];
                     }
                    
                 }else{
                     if (self.videoView.superview.bounds.size.width>self.videoView.superview.bounds.size.height) {
                         if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                             if (ISIPAD) {
                                 [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+64];
                             }else{
                                 [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+44];
                             }
                             
                         }else{
                             [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+64];
                         }
                         
                     }else{
                         if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                             if (ISIPAD) {
                                  [self.constraintTop setConstant:64.0f];
                             }else{
                                  [self.constraintTop setConstant:44.0f];
                             }
                            
                         }else{
                            [self.constraintTop setConstant:64.0f];
                         }
                         
                     }
                    
                 }
             }
             
             [self.videoView layoutIfNeeded];
         }
     }
}

- (void)setVideoHidden:(BOOL)isVideoHidden
{
    self.isHiddenVideo = isVideoHidden;
    if (self.isHiddenVideo) {
        self.videoHiddenView.hidden = NO;
        [self.videoView bringSubviewToFront:self.videoHiddenView];
        if (self.isHiddenMic) {
            [self.videoView bringSubviewToFront:self.micImageView];
        }
    }else{
        self.videoHiddenView.hidden = YES;
    }
}

- (void)setAudioClose:(BOOL)isAudioClose
{
    NSLog(@"%f   %f   %f   %f ",self.videoView.frame.origin.x, self.videoView.frame.origin.y,self.videoView.frame.size.width,self.videoView.frame.size.height);
    
    self.isHiddenMic = isAudioClose;
    if (self.isHiddenMic) {
        self.micImageView.hidden = NO;
        [self.videoView bringSubviewToFront:self.micImageView];
    }else{
        self.micImageView.hidden = YES;
    }
    if (self.videoView.superview.bounds.size.height<[UIScreen mainScreen].bounds.size.height/2) {
        self.isFull = YES;
    }else{
        self.isFull = NO;
    }
    if (self.isFull) {
        if (round(self.videoView.frame.size.height)>[UIScreen mainScreen].bounds.size.height) {
            [self.constraintTop setConstant:(round(self.videoView.frame.size.height) -[UIScreen mainScreen].bounds.size.height)/2];
        }else{
            [self.constraintTop setConstant:0.0f];
        }
    }else{
        if (round(self.videoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
            if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                [self.constraintTop setConstant:(round(self.videoView.frame.size.height) -[UIScreen mainScreen].bounds.size.height)/2+32];
                
            }else{
                [self.constraintTop setConstant:(round(self.videoView.frame.size.height) -[UIScreen mainScreen].bounds.size.height)/2+64];
            }
        }else{
            
             [self.constraintTop setConstant:0.0f];
        }
      
    }
  
    [self.videoView layoutIfNeeded];
    
}

- (void)setFullScreen:(BOOL)isFull
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isFull = isFull;
        if (round(self.videoView.frame.size.width)>=[UIScreen mainScreen].bounds.size.width) {
            [self.constraintRight setConstant:([UIScreen mainScreen].bounds.size.width-self.videoView.frame.size.width)/2];
        }else{
            [self.constraintRight setConstant:0.0f];
        }
        if (isFull) {
            if (self.constraintTop) {
    
                if (round(self.videoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
                    if (self.constraintTop.constant>0) {
                        [self.constraintTop setConstant: (self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2];
                    }else{
                         [self.constraintTop setConstant:[UIScreen mainScreen].bounds.size.height -self.videoView.frame.size.height];
                    }
                    
                }else{
                    [self.constraintTop setConstant:0.0f];
                }
                [self.videoView layoutIfNeeded];
            }
        }else{
            if (round(self.videoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
                if (self.videoView.superview.bounds.size.width>self.videoView.superview.bounds.size.height) {
                    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                        
                        [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2 +32];
                    }else{
                        [self.constraintTop setConstant:(self.videoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2 +64];
                    }
                    
                }else{
                    [self.constraintTop setConstant:64];
                }
                
            }else{
                if ([[UIApplication sharedApplication] isStatusBarHidden]) {
                    if (round(self.videoView.frame.size.height)+44>=[UIScreen mainScreen].bounds.size.height) {
                        [self.constraintTop setConstant:44.0f];
                    }else{
                        [self.constraintTop setConstant:0.0f];
                    }
                }else{
                    if (round(self.videoView.frame.size.height)+64>=[UIScreen mainScreen].bounds.size.height) {
                        [self.constraintTop setConstant:64.0f];
                    }else{
                        [self.constraintTop setConstant:0.0f];
                    }
                }
                
            }
            [self.videoView layoutIfNeeded];
            
        }
        
//        if (isFull) {
//            if (self.constraintTop) {
//                NSLog(@"%f   %f  %f",_showVideoView.frame.size.height, [UIScreen mainScreen].bounds.size.height, self.constraintTop.constant);
//                if (round(_showVideoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
//                    if (self.constraintTop.constant>0) {
//                        [self.constraintTop setConstant: (_showVideoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2];
//                    }else{
//                        [self.constraintTop setConstant:self.constraintTop.constant + 64];
//                    }
//                    
//                }else{
//                    [self.constraintTop setConstant:0.0f];
//                }
//                [_showVideoView layoutIfNeeded];
//            }
//        }else{
//             NSLog(@"%f   %f  %f",_showVideoView.frame.size.height, [UIScreen mainScreen].bounds.size.height, self.constraintTop.constant);
//            
//            if (round(_showVideoView.frame.size.height)>=[UIScreen mainScreen].bounds.size.height) {
//                if (self.constraintTop.constant>0) {
//                    if (_showVideoView.superview.bounds.size.width>_showVideoView.superview.bounds.size.height) {
//                        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
//        
//                             [self.constraintTop setConstant:(_showVideoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2 +32];
//                        }else{
//                             [self.constraintTop setConstant:(_showVideoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2 +64];
//                        }
//                        
//                    }else{
//                         [self.constraintTop setConstant:64];
//                    }
//                   
//                }else{
//                    [self.constraintTop setConstant:(_showVideoView.frame.size.height -[UIScreen mainScreen].bounds.size.height)/2+64];
//
//                }
//                
//            }else{
//                if ([[UIApplication sharedApplication] isStatusBarHidden]) {
//                    if (round(_showVideoView.frame.size.height)+44>=[UIScreen mainScreen].bounds.size.height) {
//                        [self.constraintTop setConstant:44.0f];
//                    }else{
//                        [self.constraintTop setConstant:0.0f];
//                    }
//                }else{
//                    if (round(_showVideoView.frame.size.height)+64>=[UIScreen mainScreen].bounds.size.height) {
//                        [self.constraintTop setConstant:64.0f];
//                    }else{
//                        [self.constraintTop setConstant:0.0f];
//                    }
//                }
//               
//            }
//            [_showVideoView layoutIfNeeded];
//        
//        }
    });
}

@end
