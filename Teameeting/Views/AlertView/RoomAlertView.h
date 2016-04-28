//
//  RoomAlertView.h
//  Room
//
//  Created by zjq on 15/12/8.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlertViewType) {
    AlertViewNotNetType = 0,
    AlertViewOpenNotificationType = 1,
    AlertViewModifyNameType = 2,
};
@protocol RoomAlertViewDelegate <NSObject>

- (void)modifyNickName:(NSString*)nickName;
- (void)closeModifyNickName;

@end
@interface RoomAlertView : UIView

- (id)initType:(AlertViewType)type withDelegate:(id<RoomAlertViewDelegate>)delegate;

- (void)updateFrame;

- (void)show;

- (void)dismiss;

@end
