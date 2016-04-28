//
//  RoomApp.h
//  Room
//
//  Created by zjq on 15/12/31.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface RoomApp : NSObject

+(RoomApp*)shead;

@property (nonatomic, strong) AppDelegate *appDelgate;
@property (nonatomic, strong) MainViewController *mainViewController;

- (BOOL)canSendLocalNotificationWithRoomID:(NSString *)roomID;

- (BOOL)canRemindWithLocalNotificationWithRoomID:(NSString*)roomID;
@end
