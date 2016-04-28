//
//  RoomVO.h
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RoomItem : NSObject <NSCoding>
@property (nonatomic, strong) NSString *roomName;           // meeting name
@property (nonatomic, strong) NSString *roomID;             // meeting id
@property (nonatomic, strong) NSString *userID;             // meeting own user id
@property (nonatomic, strong) NSString *canNotification;    // can notification
@property (nonatomic, assign) long jointime;                // meeting last time
@property (nonatomic, assign) long createTime;              // create meeting time
@property (nonatomic, assign) NSInteger mettingNum;         // in meeting person num
@property (nonatomic, assign) NSInteger mettingType;        // meeting type
@property (nonatomic, strong) NSString *mettingDesc;        // meeting desc
@property (nonatomic, assign) NSInteger mettingState;       // meeting state  0:no enable  1：can enable   2：private meeting
@property (nonatomic, assign) BOOL isOwn;                   // is own  1：own  0：other
@property (nonatomic, assign) NSInteger messageNum;         // no read message num
@property (nonatomic, strong) NSString *lastMessagTime;     // last message time
@property (nonatomic, strong) NSString *anyRtcID;           // anyrtcID 


- (id)initWithParams:(NSDictionary *)params;
@end

@interface RoomVO : NSObject

@property (nonatomic, strong) NSMutableArray *deviceItemsList;

- (id)initWithParams:(NSArray *)params;

@end
