//
//  GetRoomView.h
//  Room
//
//  Created by zjq on 15/11/19.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetRoomViewDelegate <NSObject>

- (void)showCancleButton;//show cancle button

- (void)cancleRename:(NSString*)oldName;    // cancle rename room name

- (void)renameRoomNameScuess:(NSString*)roomName;

- (void)getRoomWithRoomName:(NSString*)roomName withPrivateMetting:(BOOL)isPrivate; // get room name

- (void)cancleGetRoom;   // cancle get room

@end

@interface GetRoomView : UIView

@property (nonatomic, weak)id<GetRoomViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withParView:(UIView*)parview;

- (void)showGetRoomView;      // get the room

- (void)showWithRenameRoom:(NSString*)roomName;   // get the room view with rename room name

- (void)dismissView;          // dismiss the view

@end
