//
//  SpotlightManager.m
//  Teameeting
//
//  Created by jianqiangzhang on 16/3/28.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "SpotlightManager.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation SpotlightManager

static SpotlightManager *spolightManager = nil;
+(SpotlightManager*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spolightManager = [[SpotlightManager alloc] init];
    });
    return spolightManager;
}

- (void)addSearchableWithItem:(RoomItem*)item
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CSSearchableItemAttributeSet *set = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeItem];
        set.title = item.roomName;
        set.contentDescription = [NSString stringWithFormat:@"会议ID:%@",item.roomID];
        set.keywords = [NSArray arrayWithObjects:item.roomName,item.roomID,nil];
        UIImage *icon = [UIImage imageNamed:@"Icon-1@2x.png"];
        NSData *imgeData = [NSData dataWithData:UIImagePNGRepresentation(icon)];
        set.thumbnailData = imgeData;
        set.thumbnailURL =[NSURL URLWithString:@"www.teameeting.cn"];
        NSString *roomID = item.roomID;
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:roomID domainIdentifier:@"com.dync.teameeting" attributeSet:set];
        
        
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
    }
}

- (void)deleteSearchableItem:(RoomItem*)item
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        NSString *roomID = item.roomID;
        [[CSSearchableIndex defaultSearchableIndex]deleteSearchableItemsWithIdentifiers:@[roomID] completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
     }
}
- (void)updateSearchableItem:(RoomItem*)item
{
    [self deleteSearchableItem:item];
    [self addSearchableWithItem:item];
}
@end
