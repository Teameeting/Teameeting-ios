//
//  MessageView.h
//  VShowTalkDemo
//
//  Created by Zhang Jianqiang on 15/5/21.
//  Copyright (c) 2015年 Zhang Jianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MessageClearBlock)(BOOL isover,id myself);
typedef NS_ENUM(NSInteger, MessageViewType){
    MessageViewTypeText,
    MessageViewTypePic
};
@interface MessageView : UIView
/* 初始化接口，frame , 是大小 dict 包括一些内容，和类型
 dict 包括 头像信息（默认宽度为30），以及消息类型，和消息内容，发送者的名字
 */
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dict;
- (void)messageClear:(MessageClearBlock)block;
@end
