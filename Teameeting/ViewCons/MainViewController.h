//
//  MainViewController.h
//  Room
//
//  Created by yangyang on 15/11/16.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RoomVO.h"
#import "VideoViewController.h"

@interface MainViewController : BaseViewController

@property (nonatomic, strong) UITableView *roomList;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) VideoViewController *videoViewController;

- (void)insertUserMeetingRoomWithID:(RoomItem*)item;

- (void)updataDataWithServerResponse:(NSDictionary*)dict;

@end
