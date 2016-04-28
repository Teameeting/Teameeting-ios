//
//  RoomViewCell.m
//  Room
//
//  Created by zjq on 15/11/17.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "RoomViewCell.h"
#import "TimeManager.h"
#import "MemberView.h"
#import "RoomNameView.h"

#define cellHeight  60

@interface RoomViewCell()

@property (nonatomic, strong) RoomNameView *roomNameView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) MemberView *memberView;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIImageView *toplineImageView;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation RoomViewCell

@synthesize timeLabel,roomNameView,memberView,settingButton,toplineImageView,lineImageView;
@synthesize delegate;
@synthesize parIndexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self setLayout];
        
    }
    return self;
}

- (void)initSubviews
{
    self.roomNameView = [RoomNameView new];
    [self.contentView addSubview:self.roomNameView];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithRed:186.0/255.0 green:180.0/255.0 blue:189.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.timeLabel];
    
    self.memberView = [MemberView new];
    [self.contentView addSubview:self.memberView];
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settingButton setImage:[UIImage imageNamed:@"setting_main_point"] forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(settingButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.settingButton.backgroundColor = [UIColor clearColor];
//    self.accessoryView = self.settingButton;
    [self.contentView addSubview:self.settingButton];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:self.activityIndicatorView];
    
    self.toplineImageView = [UIImageView new];
    self.toplineImageView.image = [UIImage imageNamed:@""];
    self.toplineImageView.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:138.0/255.0 blue:141.0/255.0 alpha:1];
    [self.contentView addSubview:self.toplineImageView];
    
    self.lineImageView = [UIImageView new];
    self.lineImageView.image = [UIImage imageNamed:@""];
    self.lineImageView.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:138.0/255.0 blue:141.0/255.0 alpha:1];
    [self.contentView addSubview:self.lineImageView];
}

- (void)setLayout
{
    for (UIView *view in self.contentView.subviews)
    {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.settingButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.toplineImageView.frame = CGRectMake(0, -.5, [UIScreen mainScreen].bounds.size.width, .5);
    self.lineImageView.frame = CGRectMake(0, cellHeight - .5, [UIScreen mainScreen].bounds.size.width, .5);
    
    CGFloat offset = (cellHeight - 35)/2;
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self.settingButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-15.0f];
    
    NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:self.settingButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
    
     NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:self.settingButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f];
    
    NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:self.settingButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];


    NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:self.roomNameView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:offset];
    
    NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:self.roomNameView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:15.0f];
    
    NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:self.roomNameView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0f];
    
    NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:self.roomNameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.3f constant:0.f];
    

    NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.roomNameView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:offset/3];
    
    NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:15.0f];
    
    NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.6f constant:0.0f];
    
    NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.25f constant:0.f];
    

    NSLayoutConstraint * constraint12 = [NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
    
    NSLayoutConstraint * constraint13 = [NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];

    NSLayoutConstraint * constraint18 = [NSLayoutConstraint constraintWithItem:self.memberView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45.0f];
    
    NSLayoutConstraint * constraint19 = [NSLayoutConstraint constraintWithItem:self.memberView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:25.0f];
    
    NSLayoutConstraint * constraint20 = [NSLayoutConstraint constraintWithItem:self.memberView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.0f];
    
    NSLayoutConstraint * constraint21 = [NSLayoutConstraint constraintWithItem:self.memberView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.settingButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-15.f];
    
    [self.contentView addConstraint:constraint];
    [self.contentView addConstraint:constraint1];
    [self.contentView addConstraint:constraint2];
    [self.contentView addConstraint:constraint3];
    [self.contentView addConstraint:constraint4];
    [self.contentView addConstraint:constraint5];
    [self.contentView addConstraint:constraint6];
    [self.contentView addConstraint:constraint7];
    [self.contentView addConstraint:constraint8];
    [self.contentView addConstraint:constraint9];
    [self.contentView addConstraint:constraint10];
    [self.contentView addConstraint:constraint11];
    [self.contentView addConstraint:constraint12];
    [self.contentView addConstraint:constraint13];
    
    [self.contentView addConstraint:constraint18];
    [self.contentView addConstraint:constraint19];
    [self.contentView addConstraint:constraint20];
    [self.contentView addConstraint:constraint21];
}

- (void)settingButtonEvent:(UIButton*)button
{
    if (delegate && [delegate respondsToSelector:@selector(roomViewCellDlegateSettingEvent:)]) {
        [delegate roomViewCellDlegateSettingEvent:parIndexPath.row];
    }
}

- (void)setShow:(RoomItem*)item
{
    if (item.mettingState == 0) {
        self.settingButton.hidden = YES;
        [self.activityIndicatorView startAnimating];
        
    }else{
        [self.activityIndicatorView stopAnimating];
        self.settingButton.hidden = NO;
    }
    [self.roomNameView setItem:item];
    [self.memberView setRoomItem:item];
    // 是不是已经有会议了
    if ([item.roomName isEqualToString:@""]) {
        self.timeLabel.text = @"";
    }else{
        if (item.messageNum!=0) {
            self.timeLabel.text = [NSString stringWithFormat:@"(%ld)新消息:%@",(long)item.messageNum,[[TimeManager shead] friendTimeWithTimesTampStr:item.lastMessagTime]];
        }else{      
            if (item.jointime>item.createTime) {
                self.timeLabel.text = [NSString stringWithFormat:@"加入:%@",[[TimeManager shead] friendTimeWithTimesTamp:item.jointime]];
            }else{
              self.timeLabel.text = [NSString stringWithFormat:@"创建:%@",[[TimeManager shead] friendTimeWithTimesTamp:item.createTime]];
            }
            
        }
        
    }
}

- (void)setItem:(RoomItem*)item
{
     [self setShow:item];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
