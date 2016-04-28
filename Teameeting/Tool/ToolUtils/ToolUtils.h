//
//  ToolUtils.h
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NotificationType)
{
    NotificationMessageType = 0,
    NOtificationEnterMeetingType = 1,
};

@interface NotificationObject : NSObject
@property (nonatomic) NotificationType notificationType;
@property (nonatomic, strong) NSString *roomID;
@end

@interface ToolUtils : NSObject

+(ToolUtils*)shead;

@property (nonatomic)BOOL isBack;  // in background

@property (nonatomic) BOOL hasActivity;

@property (nonatomic, strong) NSString *meetingID;

@property (nonatomic, strong) NSString *roomID;

@property (nonatomic, strong) NotificationObject *notificationObject;
// 是否允许推送
+ (BOOL)isAllowedNotification;
#pragma mark - json method
//将NSString转化为NSArray或者NSDictionary
+ (id)JSONValue:(NSString*)jsonStrong;

//将NSArray或者NSDictionary转化为NSString
+ (NSData*)JSONString:(id)jsonString;

// 字典转换字符串
+ (NSString*)JSONTOString:(id)obj;

@end
