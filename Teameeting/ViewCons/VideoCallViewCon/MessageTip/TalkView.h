//
//  TalkView.h
//  VShowTalkDemo
//
//  Created by Zhang Jianqiang on 15/5/21.
//  Copyright (c) 2015年 Zhang Jianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkView : UIView
- (void)sendMessageView:(NSString*)str withUser:(NSString*)userID;
// receive
- (void)receiveMessageView:(NSString*)str withUser:(NSString*)userID withHeadPath:(NSString*)iconPath;
@end
