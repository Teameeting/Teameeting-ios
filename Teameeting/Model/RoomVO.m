//
//  RoomVO.m
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "RoomVO.h"
#import "ToolUtils.h"
#import "TimeManager.h"

@implementation RoomItem
- (id)init{
    self = [super init];
    if (self) {
        self.roomID = @"";
        self.roomName = @"";
        self.canNotification = [self canPush];
        self.mettingState = 0;
        self.jointime = [[TimeManager shead] timeTransformationTimestamp];
        self.createTime = [[TimeManager shead] timeTransformationTimestamp];
        self.messageNum = 0;
        
    }
    return self;
}
- (id)initWithParams:(NSDictionary *)params{
    if (self = [super init]) {
        if (params) {
            self.roomID = [NSString stringWithFormat:@"%@",[params valueForKey:@"meetingid"]];
            self.anyRtcID = [NSString stringWithFormat:@"%@",[params valueForKey:@"anyrtcid"]];
            self.roomName = [params valueForKey:@"meetname"];
            self.canNotification = [[params valueForKey:@"pushable"] stringValue];
            self.jointime = [[params valueForKey:@"jointime"] longValue];
            self.createTime = [[params valueForKey:@"createtime"] longValue];
            self.mettingDesc = [params valueForKey:@"meetdesc"];
            self.mettingNum = [[params valueForKey:@"memnumber"] integerValue];
            self.mettingType = [[params valueForKey:@"meettype"] integerValue];
            self.mettingState = [[params valueForKey:@"meetenable"] integerValue];
            self.userID = [params valueForKey:@"userid"];
            self.isOwn = [[params valueForKey:@"owner"] boolValue];
        }
    }
    return self;
}
- (NSString*)canPush
{
    if ([ToolUtils isAllowedNotification]) {
        return @"1";
    }else{
        return @"2";
    }
    return @"0";
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.roomName forKey:@"roomName"];
    [aCoder encodeObject:self.roomID forKey:@"roomID"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.canNotification forKey:@"canNotification"];
    [aCoder encodeInt:self.jointime forKey:@"jointime"];
    [aCoder encodeInt:self.createTime forKey:@"createtime"];
    [aCoder encodeInt:self.mettingNum forKey:@"mettingNum"];
    [aCoder encodeInteger:self.mettingType forKey:@"mettingType"];
    [aCoder encodeObject:self.mettingDesc forKey:@"mettingDesc"];
    [aCoder encodeInteger:self.mettingState forKey:@"mettingState"];
    [aCoder encodeBool:self.isOwn forKey:@"isOwn"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
       _roomName = [aDecoder decodeObjectForKey:@"roomName"];
        _roomID = [aDecoder decodeObjectForKey:@"roomID"];
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _canNotification = [aDecoder decodeObjectForKey:@"canNotification"];
        _jointime = [aDecoder decodeIntForKey:@"jointime"];
        _createTime = [aDecoder decodeIntForKey:@"createtime"];
        _mettingNum = [aDecoder decodeIntForKey:@"mettingNum"];
        _mettingType = [aDecoder decodeIntegerForKey:@"mettingType"];
        _mettingDesc = [aDecoder decodeObjectForKey:@"mettingDesc"];
        _mettingState = [aDecoder decodeIntegerForKey:@"mettingState"];
        _isOwn = [aDecoder decodeBoolForKey:@"isOwn"];
        
    }
    return self;
    
}

@end

@implementation RoomVO
- (id)initWithParams:(NSArray *)params{
    if (self = [super init]) {
        if ([params count] > 0) {
            NSMutableArray *list = [[NSMutableArray alloc]initWithCapacity:1];
            for (NSInteger i=0; i<params.count; i++) {
                NSDictionary *itemsDict = [params objectAtIndex:i];
                if (itemsDict.allKeys.count!=0) {
                    RoomItem *item = [[RoomItem alloc] initWithParams:itemsDict];
                    [list addObject:item];
                }
            }
            self.deviceItemsList = list;
        }
    }
    return self;
}
@end
