//
//  RoomApp.m
//  Room
//
//  Created by zjq on 15/12/31.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "RoomApp.h"
#import "RoomVO.h"
@implementation RoomApp
static RoomApp *roomApp = nil;
+(RoomApp*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        roomApp = [[RoomApp alloc] init];
    });
    return roomApp;
}
- (BOOL)canSendLocalNotificationWithRoomID:(NSString *)roomID
{
    if (_mainViewController && roomID) {
        for (RoomItem *roomItem in _mainViewController.dataArray) {
            if ([roomItem.roomID isEqualToString:roomID]) {
                if ([roomItem.canNotification isEqualToString:@"1"]) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
    }
    return NO;
}
- (BOOL)canRemindWithLocalNotificationWithRoomID:(NSString*)roomID
{
    if (_mainViewController && roomID) {
        if ([_mainViewController.videoViewController.roomItem.roomID isEqualToString:roomID]) {
            return NO;
        }else{
            return [self canSendLocalNotificationWithRoomID:roomID];
        }
    }
    return YES;
}

@end
