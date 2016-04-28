//
//  ToolUtils.m
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "ToolUtils.h"
#import "UIDevice+Category.h"

@implementation NotificationObject

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


@implementation ToolUtils

- (id)init
{
    self = [super init];
    if (self) {
        self.meetingID = nil;
        self.notificationObject = nil;
    }
    return self;
}
static ToolUtils *toolUtils = nil;

+(ToolUtils*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolUtils = [[ToolUtils alloc] init];
    });
    return toolUtils;
}

/**
 2  *  check if user allow local notification of system setting
 3  *
 4  *  @return YES-allowed,otherwise,NO.
 5  */
+ (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    if ([UIDevice isSystemVersioniOS8]) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    
    return NO;
}
+ (id)JSONValue:(NSString*)jsonStrong
{
    NSData* data = [jsonStrong dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
+ (NSData*)JSONString:(id)jsonString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:jsonString
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+ (NSString*)JSONTOString:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


@end
