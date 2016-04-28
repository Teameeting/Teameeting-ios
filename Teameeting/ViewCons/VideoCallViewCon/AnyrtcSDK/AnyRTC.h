//
//  AnyRTC.h
//  anrtcsdk
//
//  Created by jianqiangzhang on 16/4/20.
//  Copyright © 2016年 EricTao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AnyRTCErrorCode){
    AnyRTC_UNKNOW = 0,       // unknow error
    AnyRTC_NET_ERR = 100,    // net error
    AnyRTC_LIVE_ERR = 101,   // live error
    AnyRTC_BAD_REQ = 201,    // service request does not support the mistake
    AnyRTC_AUTH_FAIL = 202,	 // authentication failed
    AnyRTC_NO_USER = 203,	 // the developer information does not exist
    AnyRTC_SQL_ERR = 204,	 // internal database server error
    AnyRTC_ARREARS = 205,	 // account overdue bills
    AnyRTC_LOCKED = 206,	 // account is locked
    AnyRTC_FORCE_EXIT = 207, // fouce live
};

@interface AnyRTC : NSObject

/**
*  Configuration AnyRtc object.
*
*  @param developerID the developer ID of AnyRTC on the platform
*  @param token       the user's app token on the platform
*  @param appKey      the user's app key on the platform
*  @param appId       the user's app Name on the platform
*/

+ (void)InitAnyRTCWithKey:(NSString*)developerID
                withToken:(NSString*)token
               withAppKey:(NSString*)appKey
                withAppId:(NSString*)appId;

/**
 *  Update token (when login authentication,get from server by youself)
 *
 *  @param token token ,validation of the request video or audio
 */
+ (void)updateToken:(NSString*)token;

/**
 *  Get the version of AnyRTC SDK.
 *
 *  @return  sdk version
 */
+ (NSString*)getAnyRTCSdkVersion;

/**
 *  Open log Default is NO
 */
+ (void)setLogON;

@end


@interface AnyRTCVideoItem : NSObject

@property (nonatomic, strong) UIView *videoView;   // local or remote view
@property (nonatomic, strong) NSString *channelID; // the user channel ID of view
@property (nonatomic) BOOL isBack;                 // the direction of local camera (default is NO) ,if the video is remote ,the parameter is failure (Recommended not to set up)
@property (nonatomic) CGSize videoSize;            // record the video size

@end
