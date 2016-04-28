//
//  RoomNameView.m
//  Teameeting
//
//  Created by zjq on 16/1/12.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "RoomNameView.h"
#import "NSString+Category.h"
#import "SvUDIDTools.h"

@interface RoomNameView()
{
    CGSize orgSize;
}
@property (nonatomic, strong)RoomItem *roomItem;
@end

@implementation RoomNameView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        self.imageView.image = [UIImage imageNamed:@"meeting_private"];
        self.imageView.backgroundColor = [UIColor clearColor];
        
        self.nameLabel = [UILabel new];
        [self addSubview:self.nameLabel];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        NSString *nameString = @"我的会议";
        orgSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 100)];
    }
    return self;
}
- (void)layoutSubviews
{
    CGSize size = [self.roomItem.roomName sizeWithFont:[UIFont boldSystemFontOfSize:16] maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 100)];
    if (size.height> orgSize.height) {
        self.nameLabel.frame = CGRectMake(0, 0, self.bounds.size.width-self.bounds.size.height/3*2, self.bounds.size.height);
        self.imageView.frame = CGRectMake(CGRectGetWidth(self.nameLabel.frame), self.bounds.size.height/6, self.bounds.size.height/3*2, self.bounds.size.height/3*2);
    }else{
        if (size.width > self.bounds.size.width-self.bounds.size.height-5) {
            self.nameLabel.frame = CGRectMake(0, 0, self.bounds.size.width-self.bounds.size.height/3*2-5, self.bounds.size.height);
            self.imageView.frame = CGRectMake(CGRectGetWidth(self.nameLabel.frame)+5, self.bounds.size.height/6, self.bounds.size.height/3*2, self.bounds.size.height/3*2);
        }else{
            self.nameLabel.frame = CGRectMake(0, 0, size.width, self.bounds.size.height);
            self.imageView.frame = CGRectMake(CGRectGetWidth(self.nameLabel.frame)+5, self.bounds.size.height/6, self.bounds.size.height/3*2, self.bounds.size.height/3*2);
        }
        
    }
}

- (void)setItem:(RoomItem*)item
{
    self.roomItem = item;
    if ([item.roomName isEqualToString:@""]) {
        self.imageView.hidden = YES;
    }else{
        
        if ([item.userID isEqualToString:[SvUDIDTools shead].UUID]) {
            self.nameLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
            if (item.mettingState ==2) {
                //private meeting
                self.imageView.hidden = NO;
            }else{
                self.imageView.hidden = YES;
            }
        }else{
            self.nameLabel.textColor = [UIColor whiteColor];
            self.imageView.hidden = YES;
        }
    }
    self.nameLabel.text = item.roomName;

    [self layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
