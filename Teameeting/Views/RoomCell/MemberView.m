//
//  MemberView.m
//  Room
//
//  Created by zjq on 15/12/30.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "MemberView.h"

@interface MemberView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *notificationImageView;
@property (nonatomic, strong) UILabel *numberLabel;
- (void)layout;
@end

@implementation MemberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        self.imageView.image = [UIImage imageNamed:@"meeting_num"];
        
        self.notificationImageView = [[UIImageView alloc] init];
        [self addSubview:self.notificationImageView];
        self.notificationImageView.image = [UIImage imageNamed:@"metting_nonotification"];
        self.notificationImageView.hidden = YES;
        
        self.numberLabel = [UILabel new];
        [self addSubview:self.numberLabel];
        self.numberLabel.textAlignment = NSTextAlignmentLeft;
        self.numberLabel.textColor = [UIColor colorWithRed:181.0/255.0f green:181.0/255.0f blue:182.0/255.0f alpha:1.0f];
        self.numberLabel.font = [UIFont boldSystemFontOfSize:16];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        [self layout];
    }
    return self;
}
- (void)layout
{
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.notificationImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.8f constant: 0];
    
    NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.8f constant:0];
    
     NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    
     NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];
    
    
    NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    
    NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeRight multiplier:1.0f constant: 2.f];
    
    NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
    NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:.0f];
    
    NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:_notificationImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.9f constant:0.f];
    
    NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:_notificationImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.85f constant: .0f];
    
    NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:_notificationImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:_notificationImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:.0f];
    
    
    [self addConstraint:constraint];
    [self addConstraint:constraint1];
    [self addConstraint:constraint2];
    [self addConstraint:constraint3];
    [self addConstraint:constraint4];
    [self addConstraint:constraint5];
    [self addConstraint:constraint6];
    [self addConstraint:constraint7];
    [self addConstraint:constraint8];
    [self addConstraint:constraint9];
    [self addConstraint:constraint10];
    [self addConstraint:constraint11];
    
}

- (void)setRoomItem:(RoomItem*)roomItem
{
    if ([roomItem.roomName isEqualToString:@""]) {
        self.numberLabel.hidden = YES;
        self.imageView.hidden = YES;
        self.notificationImageView.hidden = YES;
    }else{
        if (roomItem.mettingNum == 0) {
            self.numberLabel.hidden = YES;
            self.imageView.hidden = YES;
            if ([roomItem.canNotification isEqualToString:@"1"]) {
                self.notificationImageView.hidden = YES;
            }else{
                self.notificationImageView.hidden = NO;
            }
        }else{
            self.numberLabel.hidden = NO;
            self.imageView.hidden = NO;
            self.notificationImageView.hidden = YES;
            self.numberLabel.text =  [NSString stringWithFormat:@"%ld",(long)roomItem.mettingNum];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
