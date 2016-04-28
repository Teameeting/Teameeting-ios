//
//  TalkView.m
//  VShowTalkDemo
//
//  Created by Zhang Jianqiang on 15/5/21.
//  Copyright (c) 2015年 Zhang Jianqiang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TalkView.h"
#import "MessageView.h"
#import "MLEmojiLabel.h"
#import "ConvertToCommonEmoticonsHelper.h"

#define headWidth  30
#define bottonHeigthOrLeftAligain 10
#define messagespace 5
@interface TalkView()
{
    
}
- (CGSize)sizeWithNeiRong:(NSDictionary*)dict;

@property (nonatomic, strong) NSMutableArray *_dataArr;
@property (nonatomic, strong) NSMutableArray *_saveArr;
@property (nonatomic, strong) MLEmojiLabel *textLabel;
@end

@implementation TalkView
@synthesize _dataArr,_saveArr;
@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:5];
        textLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return NO;
    
}

- (CGSize)sizeWithNeiRong:(NSDictionary*)dict
{
    NSString *userName = [dict objectForKey:@"userID"];
    NSString *content = [dict objectForKey:@"content"];
    // 用户名
    UIFont *fontUser = [UIFont systemFontOfSize:11.0f];;
    CGSize UserSize = [userName boundingRectWithSize:CGSizeMake(self.bounds.size.width - headWidth -10 -70, 100) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : fontUser} context:nil].size;
    // 内容
    textLabel.text = content;
    CGSize brandSize= [textLabel preferredSizeWithMaxWidth:self.bounds.size.width -headWidth -10 -70];
    
    if (UserSize.width > brandSize.width) {
        UserSize.width = UserSize.width + headWidth + 16;
        UserSize.height = UserSize.height + brandSize.height + 6;
        return UserSize;
    }else{
        brandSize.width = brandSize.width + headWidth + 16;
        brandSize.height = UserSize.height + brandSize.height + 6;
        return brandSize;
    }
    return CGSizeZero;

}
- (void)receiveMessageView:(NSString*)str withUser:(NSString*)userID withHeadPath:(NSString*)iconPath
{
    NSString *string = [ConvertToCommonEmoticonsHelper convertToSystemEmoticons:str];
    NSDictionary *dict;
    if (iconPath) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:string,@"content", userID,@"userID", iconPath, @"icon",nil];
    }else{
        dict = [NSDictionary dictionaryWithObjectsAndKeys:string,@"content", userID,@"userID", nil];
    }
    CGSize size = [self sizeWithNeiRong:dict];
    
    MessageView *message1 = [[MessageView alloc] initWithFrame:CGRectMake(10, 0 - size.height, size.width, size.height) withDic:dict];
    __block TalkView *_self = self;
    // 设置回调
    [message1 messageClear:^(BOOL isover, id myself) {
        [_self removeObject:myself];
    }];
    [_dataArr addObject:message1];
    [self addSubview:message1];
    [self animationlayoutSubviews];
}

- (void)sendMessageView:(NSString*)str withUser:(NSString*)userID;
{
   // NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"content", userID,@"userID",nil];
    CGSize size = [self sizeWithNeiRong:dict];

    MessageView *message1 = [[MessageView alloc] initWithFrame:CGRectMake(10, -100, size.width, size.height) withDic:dict];
    message1.alpha = 0.8f;
    __block TalkView *_self = self;
    // 设置回调
    [message1 messageClear:^(BOOL isover, id myself) {
        [_self removeObject:myself];
    }];
    [_dataArr addObject:message1];
    [self addSubview:message1];
    [self animationlayoutSubviews];
}
- (void)removeObject:(id)sender
{
    @autoreleasepool {
        @synchronized(_dataArr){
            [_dataArr removeObject:sender];
        }
    }
   
}
- (void)animationlayoutSubviews
{
    [UIView animateWithDuration:0.3 animations:^{
        @synchronized(_dataArr){
            int allnum = (int)_dataArr.count -1;
            for (int i= allnum; i>=0; i--) {
                if (i==allnum) {
                    MessageView *message = [_dataArr objectAtIndex:i];
                    message.frame = CGRectMake(bottonHeigthOrLeftAligain, 0, message.bounds.size.width, message.bounds.size.height);
                    
                }else{
                    MessageView *lastMessage = [_dataArr objectAtIndex:i+1];
                    MessageView *newMessage = [_dataArr objectAtIndex:i];
                    
                    newMessage.frame = CGRectMake(bottonHeigthOrLeftAligain, CGRectGetMaxY(lastMessage.frame) + messagespace, newMessage.bounds.size.width, newMessage.bounds.size.height);
                    
                }
            }
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
