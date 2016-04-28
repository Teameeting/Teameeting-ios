//
//  TimeManager.m
//  Room
//
//  Created by zjq on 15/12/10.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "TimeManager.h"
#import "NSDate+Utils.h"

@implementation TimeManager

static TimeManager *timeManger = nil;

+(TimeManager*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeManger = [[TimeManager alloc] init];
    });
    return timeManger;
}
-(NSString *)friendTimeWithTimesTampStr:(NSString*)timestamp
{
    long time = [timestamp longLongValue];
    return [self friendTimeWithTimesTamp:time];
}

//智能时间处理 传入时间戳
-(NSString *)friendTimeWithTimesTamp:(long)timestamp
{
    if (timestamp<10) {
        return @"";
    }
    long bb=  timestamp/1000;
    
    NSDate* createdAt = [NSDate dateWithTimeIntervalSince1970:bb];
    NSString *Str = [NSString stringWithFormat:@"%@",createdAt];
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:lastDate];
    lastDate = [lastDate dateByAddingTimeInterval:interval];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        if (labs([[NSDate date] day] - (long)[lastDate day])<=1) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
            if ([lastDate hour]>=5 && [lastDate hour]<12) {
                period = @"上午";
                hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
            }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
                period = @"下午";
                hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
            }else if ([lastDate hour]>18 && [lastDate hour]<=23){
                period = @"晚上";
                hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
            }else{
                period = @"早上";
                hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
            }
            return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
            
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    return [NSString stringWithFormat:@"%@ %02d:%02d",dateStr,(int)[lastDate hour],(int)[lastDate minute]];
}
// 得到时间戳
- (long)timeTransformationTimestamp
{
    NSDateFormatter *formatter = [self dateFormatter];
    NSString* stringData = [formatter stringFromDate:[NSDate date]];
    NSDate* date = [formatter dateFromString:stringData];
    return (long)[date timeIntervalSince1970]*1000;
}

-(NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

// 时间戳转换为时间
- (NSString*)timestampTransformationTime:(long)timestamp
{
//    NSDateFormatter *formatter = [self dateFormatter];
    long bb=  timestamp/1000;
    //时间戳转时间的方法:
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:bb];
    return [confromTimesp description];
}

//判断date_是否在当前星期
- (BOOL)isDateThisWeek:(NSDate *)date_
{
    NSDate *start;
    NSTimeInterval extends;
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    // 用于返回日期date(参数)所在的那个日历单元unit(参数)的开始时间(sDate)。其中参数unit指定了日历单元，参数sDate用于返回日历单元的第一天，参数unitSecs用于返回日历单元的长度(以秒为单位)，参数date指定了一个特定的日期。
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval:&extends forDate:today];
    if(!success)return NO;
    NSTimeInterval dateInSecs = [date_ timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
