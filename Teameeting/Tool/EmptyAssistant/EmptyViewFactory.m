//
//  OFFemptyFactory.m
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "EmptyViewFactory.h"

@implementation EmptyViewFactory

#pragma mark - modelConfig

// 首页启动占位图(无按钮)
+ (void)emptyMainView:(UIScrollView *)scrollView
{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:@"no_room"];
    configer.emptyTitle = @"创建你的第一个房间";
    configer.emptyTitleColor = [UIColor whiteColor];
    configer.emptyTitleFont = [UIFont systemFontOfSize:18];
    configer.emptySubtitle = @"赶紧创建一个房间吧，你可以分享链接给你的好友，也可以通过短信／微信邀请其他人，让我们面对面的聊天吧！";
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
    
    [(UITableView *)scrollView reloadData];
}

@end
