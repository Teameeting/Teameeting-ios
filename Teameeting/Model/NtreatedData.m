//
//  ntreatedData.m
//  Room
//
//  Created by yangyang on 15/12/18.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "NtreatedData.h"

@implementation NtreatedData

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.lastModifyDate forKey:@"lastModifyDate"];
    [aCoder encodeInt:self.actionType forKey:@"actionType"];
    [aCoder encodeObject:self.item forKey:@"item"];
    [aCoder encodeObject:self.udid forKey:@"udid"];
    [aCoder encodeBool:self.isPrivate forKey:@"isPrivate"];
    [aCoder encodeBool:self.isNotification forKey:@"isNotification"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
     
       _lastModifyDate = [aDecoder decodeObjectForKey:@"lastModifyDate"];
       _actionType = [aDecoder decodeIntForKey:@"actionType"];
       _item = [aDecoder decodeObjectForKey:@"item"];
       _udid = [aDecoder decodeObjectForKey:@"udid"];
       _isPrivate = [aDecoder decodeBoolForKey:@"isPrivate"];
       _isNotification = [aDecoder decodeBoolForKey:@"isNotification"];
    }
    return self;
}

@end
