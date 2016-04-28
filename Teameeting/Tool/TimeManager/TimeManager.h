//
//  TimeManager.h
//  Room
//
//  Created by zjq on 15/12/10.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

+(TimeManager*)shead;

//智能时间处理 传入时间戳
-(NSString *)friendTimeWithTimesTamp:(long)timestamp;

-(NSString *)friendTimeWithTimesTampStr:(NSString*)timestamp;

// 时间戳转换为时间
- (NSString*)timestampTransformationTime:(long)timestamp;

// 目前时间转换为时间戳
- (long)timeTransformationTimestamp;

@end
