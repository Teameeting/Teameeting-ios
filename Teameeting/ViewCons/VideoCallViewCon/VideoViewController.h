//
//  VideoViewController.h
//  Teameeting
//
//  Created by zjq on 16/1/21.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomVO.h"
#import "ASBadgeView.h"

@interface VideoViewController : UIViewController
@property (nonatomic, strong) RoomItem *roomItem;
@property(nonatomic,strong)ASBadgeView *badgeView;
@property (nonatomic, copy)void(^DismissVideoViewController)(void);

- (void)tapEvent:(UITapGestureRecognizer*)tap;

- (BOOL)isVertical;
- (void)openOrCloseTalk:(BOOL)isOpen;
- (void)dismissMyself;
@end
