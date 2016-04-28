//
//  SpotlightManager.h
//  Teameeting
//
//  Created by jianqiangzhang on 16/3/28.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomVO.h"

@interface SpotlightManager : NSObject

+(SpotlightManager*)shead;

- (void)addSearchableWithItem:(RoomItem*)item;

- (void)deleteSearchableItem:(RoomItem*)item;

- (void)updateSearchableItem:(RoomItem*)item;

@end
