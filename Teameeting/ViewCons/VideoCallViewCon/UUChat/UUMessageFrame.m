//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageFrame.h"
#import "UUMessage.h"

@implementation UUMessageFrame

- (void)setMessage:(UUMessage *)message {
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [_message.strTime sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (_message.from == UUMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatIconWH, ChatIconWH, 20);
    
    // 4、计算内容位置
    //CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentX = ChatMargin;
    CGFloat contentY = iconY;
    
    //根据种类分
    CGSize contentSize;
    switch (_message.type) {
        case UUMessageTypeText:
            contentSize = [_message.strContent sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            contentSize = CGSizeMake(ChatContentW, contentSize.height);
            break;
        case UUMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            break;
        case UUMessageTypeVoice:
            contentSize = CGSizeMake(120, 20);
            break;
        default:
            break;
    }
    if (_message.from == UUMessageFromMe) {
        contentX = screenW - contentSize.width - ChatContentRight*8;
        //contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
}

- (void)setMessage:(UUMessage *)message isVertical:(BOOL)vertical{
    
    _message = message;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (!vertical) {
        
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        screenW = screenW > screenH ? screenW : screenH;
    }
    if (ISIPAD) {
        screenW = TalkPannelWidth;
//        if (vertical) {
//            
//            screenW = [UIScreen mainScreen].bounds.size.width/2 - 50;
//            
//        } else {
//            
//            CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
//            screenW = screenW > screenH ? screenW : screenH;
//            screenW = screenW/2 - 100;
//        }
    }
    
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [_message.strTime sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (_message.from == UUMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatIconWH, ChatIconWH, 20);
    
    // 4、计算内容位置
    //CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentX = ChatMargin;
    CGFloat contentY = iconY;
    
    //根据种类分
    CGSize contentSize;
    switch (_message.type) {
        case UUMessageTypeText:
            contentSize = [_message.strContent sizeWithFont:ChatContentFont  constrainedToSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            contentSize = CGSizeMake(ChatContentW, contentSize.height);
            break;
        case UUMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            break;
        case UUMessageTypeVoice:
            contentSize = CGSizeMake(120, 20);
            break;
        default:
            break;
    }
    if (_message.from == UUMessageFromMe) {
        contentX = screenW - contentSize.width - ChatContentRight*3;
        //contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
    
}

@end
