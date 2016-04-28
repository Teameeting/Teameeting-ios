//
//  ntreatedData.h
//  Room
//
//  Created by yangyang on 15/12/18.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RoomVO.h"
typedef enum  ActionType {
    
    ModifyRoomName,
    CreateRoom,
    DeleteRoom,
    SettingNotificationRoom,
    SettingPrivateRoom,
    
} ActionType;

@interface NtreatedData : NSObject<NSCoding>


@property(nonatomic,strong)NSDate *lastModifyDate;
@property(nonatomic,assign)ActionType actionType;
@property(nonatomic,strong)RoomItem* item;
@property(nonatomic,assign)BOOL isPrivate;
@property(nonatomic,strong)NSString *udid;
@property (nonatomic,assign)BOOL isNotification;
@end
