//
//  RoomViewCell.h
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomVO.h"

@protocol RoomViewCellDelegate <NSObject>

- (void)roomViewCellDlegateSettingEvent:(NSInteger)index;

@end

@interface RoomViewCell : UITableViewCell

@property (nonatomic, weak)id<RoomViewCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *parIndexPath;
// set item 
- (void)setItem:(RoomItem*)item;

@end
