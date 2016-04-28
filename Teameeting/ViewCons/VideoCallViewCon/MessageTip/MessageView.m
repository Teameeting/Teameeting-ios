//
//  MessageView.m
//  VShowTalkDemo
//
//  Created by Zhang Jianqiang on 15/5/21.
//  Copyright (c) 2015年 Zhang Jianqiang. All rights reserved.
//

#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>
#import "MLEmojiLabel.h"
#import "UIImageView+AFNetworking.h"

@interface MessageView()<MLEmojiLabelDelegate>
{
    MessageClearBlock _block;
    
}
@property (nonatomic, strong) MLEmojiLabel *textLabel;
@end

@implementation MessageView
@synthesize textLabel;

- (void)dealloc
{
    textLabel = nil;
   
    NSLog(@"dealloc");
}
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dict
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        [self performSelector:@selector(clearEvent) withObject:nil afterDelay:3];
        // 头像
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, frame.size.height)];
         headImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (![[dict objectForKey:@"icon"] isEqualToString:@""]&& [dict objectForKey:@"icon"]) {
            [headImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"icon"]]];
        }else{
            headImageView.backgroundColor = [UIColor redColor];
        }
        headImageView.layer.masksToBounds = YES;
        //[self addSubview:headImageView];
        
        NSString *userName = [dict objectForKey:@"userID"];
        NSString *content = [dict objectForKey:@"content"];
        // 用户名
        UIFont *fontUser = [UIFont systemFontOfSize:11.0f];
        CGSize UserSize = [userName boundingRectWithSize:CGSizeMake(self.bounds.size.width -30, 100) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : fontUser} context:nil].size;
        // userName 的显示
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+8, 3, UserSize.width, UserSize.height)];
        userNameLabel.font = fontUser;
        userNameLabel.textColor = [UIColor grayColor];
        userNameLabel.text = userName;
        //[self addSubview:userNameLabel];
        
        // 内容
        textLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        textLabel.text = content;
        CGSize  size = [textLabel preferredSizeWithMaxWidth:self.bounds.size.width - 16];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:14.0f];
        textLabel.delegate = self;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.frame = CGRectMake(8, 8, size.width, size.height);
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.isNeedAtAndPoundSign = YES;
        textLabel.disableThreeCommon = YES;
        textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        textLabel.customEmojiPlistName = @"expressionImage_custom";
        [self addSubview:textLabel];
    }
    return self;
}

- (void)messageClear:(MessageClearBlock)block
{
    _block = block;
}
- (void)clearEvent
{
    [UIView animateWithDuration:2 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        _block(YES,self);
        if (_block) {
            _block = nil;
        }
        [self removeFromSuperview];
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
