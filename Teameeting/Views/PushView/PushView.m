//
//  PushView.m
//  DemoAnnitation
//
//  Created by yangyang on 15/11/3.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import "PushView.h"
#import "ToolUtils.h"
#define IPADCellWidth 480
#define CellHeight 60
@protocol SelectedItemCellDelegate <NSObject>

- (void)selectedItemCell:(NSInteger)index;

- (void)openOrCloseNotification:(BOOL)isOpen;

- (void)privateMeeting:(BOOL)isPrivate;

@end

@interface SelectedItemCell : UIView<UIAlertViewDelegate>
{
    UIImageView  *iconImageView;
    UILabel      *titleLabel;
    UISwitch     *switchView;
    NSInteger    indexPath;
    UIImageView *lineImageView;
    UIImageView *notificationLineImageView;
    PushViewType viewType;
    RoomItem *roomItem;
    
    BOOL tryOpen;
}
@property (nonatomic, assign) BOOL isViewEnable;

@property (nonatomic, weak)id<SelectedItemCellDelegate>delegate;

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString*)title
      withImageName:(NSString*)imageName
    withEnableImage:(NSString*)enableImageName
           withType:(PushViewType)type
          withIndex:(NSInteger)index
           withItem:(RoomItem*)item;

- (void)setViewEnable:(BOOL)isEnable;

@end

@implementation SelectedItemCell
@synthesize delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString*)title
      withImageName:(NSString*)imageName
    withEnableImage:(NSString*)enableImageName
           withType:(PushViewType)type
          withIndex:(NSInteger)index
           withItem:(RoomItem *)item {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        roomItem = item;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.isViewEnable = YES;
        indexPath = index;
        viewType = type;
        iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:iconImageView];
        
        titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        lineImageView = [UIImageView new];
        lineImageView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineImageView];
        
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickSelectedItemCell:)]];
        
        if ((type == PushViewTypeSetting||type == PushViewTypeSettingConferee) && index == 4) {
            tryOpen = NO;

            switchView = [UISwitch new];
            switchView.onTintColor = [UIColor colorWithRed:235.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
            switchView.tag = index;
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:switchView];
            
            if ([item.canNotification isEqualToString:@"1"]) {
                notificationLineImageView = [UIImageView new];
                notificationLineImageView.transform = CGAffineTransformMakeScale(.0, .0);
                notificationLineImageView.tag = 300;
                notificationLineImageView.center = iconImageView.center;
                notificationLineImageView.image = [UIImage imageNamed:@"notification_line_main"];
                [self addSubview:notificationLineImageView];
                switchView.on = YES;
            }else{
                notificationLineImageView = [UIImageView new];
                notificationLineImageView.tag = 300;
                notificationLineImageView.center = iconImageView.center;
                notificationLineImageView.image = [UIImage imageNamed:@"notification_line_main"];
                [self addSubview:notificationLineImageView];
                switchView.on = NO;
            }
          
        }else if (type == PushViewTypeSetting && index == 7){
            switchView = [UISwitch new];
            switchView.onTintColor = [UIColor colorWithRed:235.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
            switchView.tag = index;
            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:switchView];
            if (item.mettingState ==2) {
                switchView.on = YES;
            }else{
                switchView.on = NO;
            }
        }
        [self layout];
        
    }
    return self;
}

- (void)layout
{
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    lineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    switchView.translatesAutoresizingMaskIntoConstraints = NO;
    notificationLineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    // icon
    NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:36.0f];
    
    NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:36.0f];
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:iconImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint0 = [NSLayoutConstraint constraintWithItem:iconImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
    
    // title
    NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:150.0f];
    
    NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:25.0f];
    
    NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeRight multiplier:1.0f constant:15.0f];
    
    // top line
    NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:15.0f];
    
    NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:1.0f];
    
    NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-15.0f];
    
    NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-1.0f];
    
    [self addConstraint:constraint0];
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
    
    if (switchView) {
        // switch
        NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:switchView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
        
        NSLayoutConstraint * constraint12 = [NSLayoutConstraint constraintWithItem:switchView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0];
        [self addConstraint:constraint11];
        [self addConstraint:constraint12];
        
        if (switchView.tag ==4 ) {
            // close switch image
            NSLayoutConstraint * constraint13 = [NSLayoutConstraint constraintWithItem:notificationLineImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
            
            NSLayoutConstraint * constraint14 = [NSLayoutConstraint constraintWithItem:notificationLineImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
            
            NSLayoutConstraint * constraint15 = [NSLayoutConstraint constraintWithItem:notificationLineImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            NSLayoutConstraint * constraint16 = [NSLayoutConstraint constraintWithItem:notificationLineImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            [self addConstraint:constraint13];
            [self addConstraint:constraint14];
            [self addConstraint:constraint15];
            [self addConstraint:constraint16];
        }
      
    }
   
}
// setting self enable
- (void)setViewEnable:(BOOL)isEnable
{
    if (isEnable) {// enable
         self.isViewEnable = YES;
        titleLabel.textColor = [UIColor whiteColor];
    }else{// no enable
         self.isViewEnable = NO;
         titleLabel.textColor = [UIColor grayColor];
    }
}

- (void)notificationShow:(BOOL)isShow
{
    UIImageView *lineImage = (UIImageView*)[self viewWithTag:300];
    if (!isShow) {
        [UIView animateWithDuration:.3
                         animations:^{
                             lineImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }];
        
       
    }else{
        [UIView animateWithDuration:.3
                         animations:^{
                             lineImage.transform = CGAffineTransformMakeScale(0, 0);
                         }];
    }
}
// tap cell
- (void)onClickSelectedItemCell:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (!self.isViewEnable) {
        return;
    }
    if (viewType == PushViewTypeSetting && indexPath == 4) {
        if (switchView) {
            if (switchView.isOn) {
                [switchView setOn:NO animated:YES];
                [self notificationShow:NO];
            }else{
                [self getNOtificationAuthority];
            }
        }
    }else if (viewType == PushViewTypeSetting && indexPath ==7){
        // open private
        if (switchView) {
            if (switchView.isOn) {
                 [switchView setOn:NO animated:YES];
                if (delegate && [delegate respondsToSelector:@selector(privateMeeting:)]) {
                    [delegate privateMeeting:NO];
                }
            }else{
                [switchView setOn:YES animated:YES];
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打开私密会议，您将不能在分享该会议给好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alerView.tag = 491;
                [alerView show];
            }
        }
    }else{
        if (delegate && [delegate respondsToSelector:@selector(selectedItemCell:)]) {
            [delegate selectedItemCell:indexPath];
        }
    }
}
//
- (void)switchAction:(UISwitch*)view
{
    int tag = (int)view.tag;
    if (tag == 4) {
        // open
        if (view.isOn) {
            // 先判断能否打开在打开否则回去
            [self getNOtificationAuthority];
        }else{// close
            [self notificationShow:NO];
            if (delegate && [delegate respondsToSelector:@selector(openOrCloseNotification:)]) {
                [delegate openOrCloseNotification:NO];
            }
        }
    }else{
        // open private
        if (view.isOn) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打开私密会议，您将不能在分享该会议给好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alerView.tag = 491;
            [alerView show];
            
        }else{// close
            if (delegate && [delegate respondsToSelector:@selector(privateMeeting:)]) {
                [delegate privateMeeting:NO];
            }
        }
    }
   
}

- (void)getNOtificationAuthority
{
    
    if ([ToolUtils isAllowedNotification]) {
        [switchView setOn:YES animated:YES];
        [self notificationShow:YES];
        // can notification
        if (delegate && [delegate respondsToSelector:@selector(openOrCloseNotification:)]) {
            [delegate openOrCloseNotification:YES];
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            tryOpen = YES;
            [switchView setOn:NO animated:YES];
        });
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"打开通知" message:@"去设置当中，把推送通知打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        alerView.tag = 490;
        [alerView show];
    }
}
- (void)applicationDidBecomeActive
{
    if (tryOpen) {
        [switchView setOn:YES animated:YES];
        if (delegate && [delegate respondsToSelector:@selector(openOrCloseNotification:)]) {
            [delegate openOrCloseNotification:YES];
        }
    }
   
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 490) {
        if (buttonIndex == 0) {
            tryOpen = NO;
        }else{
            if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
                NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:appSettings];
            }else{
                NSURL*url=[NSURL URLWithString:@"app-settings:"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }

    }else if (alertView.tag == 491){
        if (buttonIndex == 1) {
            if (delegate && [delegate respondsToSelector:@selector(privateMeeting:)]) {
                [delegate privateMeeting:YES];
            }
            
        }else{
            switchView.on = NO;
        }
    }
}

@end


@interface PushView ()<UIScrollViewDelegate,SelectedItemCellDelegate>
{
    SelectedItemCell *messageInviteView;
    SelectedItemCell *weixinInviteView;
    SelectedItemCell *copyInviteView;
}
@property (nonatomic, strong) UIScrollView *mainScrllView;
@property (nonatomic) PushViewType lastPushViewType;
@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, assign) NSInteger index;
@end


@implementation PushView
@synthesize delegate;
@synthesize lastPushViewType;
@synthesize titleLabel;
@synthesize lineImageView;

@synthesize roomItem;

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        lastPushViewType = PushViewTypeNone;
        
        self.upButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.frame.size.width, 40)];
        [self.upButton setTitle:@"关闭" forState:UIControlStateNormal];
        [self.upButton setCenter:CGPointMake(self.bounds.size.width/2, self.upButton.center.y)];
        [self.upButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.upButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor blackColor];
         self.mainScrllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.mainScrllView.delegate = self;
      
        self.mainScrllView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.mainScrllView];
        
        UIView *shadowView = [UIView new];
        shadowView.tag = 401;
        [self addSubview:shadowView];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = shadowView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.1].CGColor,(id)[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.9].CGColor,nil];
        [shadowView.layer insertSublayer:gradient atIndex:0];
        [self addSubview:self.upButton];
        
        shadowView.translatesAutoresizingMaskIntoConstraints = NO;
        // 遮罩
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f];
        NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-40.0f];
        
        [self addConstraint:constraint];
        [self addConstraint:constraint1];
        [self addConstraint:constraint2];
        
    }
    self.hidden = YES;
    self.alpha = 0;
    self.upButton.alpha = 0;
    [self.mainScrllView setFrame:CGRectMake(0, self.frame.size.height, self.mainScrllView.bounds.size.width, self.mainScrllView.frame.size.height)];
    
    return self;
}


- (void)showViewOptionWithType:(PushViewType)type
{
    CGFloat startY = self.frame.size.height/2 - 40;
    // title
    if (!titleLabel) {
        titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.text = roomItem.roomName;
        [self.mainScrllView addSubview:titleLabel];
    }else{
        titleLabel.text = roomItem.roomName;
    }
    if (!lineImageView) {
        lineImageView = [UIImageView new];
        lineImageView.backgroundColor = [UIColor grayColor];
        [self.mainScrllView addSubview:lineImageView];
    }
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    lineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    // layout
    if (ISIPAD) {
        // title
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainScrllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:startY];
        
        NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:IPADCellWidth];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScrllView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f];
        // line
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20];
        
        NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:IPADCellWidth+40];
        
        NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:1.0f];
        
        NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-20.f];
        
        [self.mainScrllView addConstraint:constraint];
        [self.mainScrllView addConstraint:constraint1];
        [self.mainScrllView addConstraint:constraint2];
        [self.mainScrllView addConstraint:constraint3];
        [self.mainScrllView addConstraint:constraint4];
        [self.mainScrllView addConstraint:constraint5];
        [self.mainScrllView addConstraint:constraint6];
        [self.mainScrllView addConstraint:constraint7];
        
    }else{
        // title
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainScrllView attribute:NSLayoutAttributeTop multiplier:1.0f constant:startY];
        
        NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CGRectGetWidth(self.frame)-40];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainScrllView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f];
        // line(0, CGRectGetMaxY(titleLabel.frame)+ 20, self.frame.size.width, 1)];
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20];
        
        NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CGRectGetWidth(self.frame)];
        
        NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:1.0f];
        
        NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mainScrllView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        [self.mainScrllView addConstraint:constraint];
        [self.mainScrllView addConstraint:constraint1];
        [self.mainScrllView addConstraint:constraint2];
        [self.mainScrllView addConstraint:constraint3];
        [self.mainScrllView addConstraint:constraint4];
        [self.mainScrllView addConstraint:constraint5];
        [self.mainScrllView addConstraint:constraint6];
        [self.mainScrllView addConstraint:constraint7];
    }

    
    // remove all old itmes
    for (id itemView in self.mainScrllView.subviews) {
        if ([itemView isKindOfClass:[SelectedItemCell class]]) {
            [itemView removeFromSuperview];
        }
    }
    startY = CGRectGetMaxY(lineImageView.frame);
    
    if (type == PushViewTypeDefault) {
        SelectedItemCell *inviteMessage = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"短信邀请" withImageName:@"message_main" withEnableImage:nil withType:PushViewTypeDefault withIndex:0 withItem:roomItem];
        inviteMessage.delegate = self;
        
         SelectedItemCell *inviteMail = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"微信邀请" withImageName:@"mail_main" withEnableImage:nil withType:PushViewTypeDefault withIndex:1 withItem:roomItem];
        inviteMail.delegate = self;
        
         SelectedItemCell *inviteLink = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"拷贝链接" withImageName:@"link_main" withEnableImage:nil withType:PushViewTypeDefault withIndex:2 withItem:roomItem];
        inviteLink.delegate = self;
        
        [self.mainScrllView addSubview:inviteMessage];
        [self.mainScrllView addSubview:inviteMail];
        [self.mainScrllView addSubview:inviteLink];
        
        inviteMessage.translatesAutoresizingMaskIntoConstraints = NO;
        inviteMail.translatesAutoresizingMaskIntoConstraints = NO;
        inviteLink.translatesAutoresizingMaskIntoConstraints = NO;
        //inviteMessage
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:inviteMessage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:inviteMessage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:inviteMessage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:inviteMessage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //inviteMail
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:inviteMail attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:inviteMessage attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:inviteMail attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:inviteMail attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:inviteMail attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //inviteLink
        NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:inviteLink attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:inviteMail attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:inviteLink attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:inviteLink attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:inviteLink attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        [self.mainScrllView addConstraint:constraint];
        [self.mainScrllView addConstraint:constraint1];
        [self.mainScrllView addConstraint:constraint2];
        [self.mainScrllView addConstraint:constraint3];
        [self.mainScrllView addConstraint:constraint4];
        [self.mainScrllView addConstraint:constraint5];
        [self.mainScrllView addConstraint:constraint6];
        [self.mainScrllView addConstraint:constraint7];
        [self.mainScrllView addConstraint:constraint8];
        [self.mainScrllView addConstraint:constraint9];
        [self.mainScrllView addConstraint:constraint10];
        [self.mainScrllView addConstraint:constraint11];
        
    }else if(type == PushViewTypeSetting){
        SelectedItemCell *joinRoom = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"进入会议" withImageName:@"enter_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:0 withItem:roomItem];
        joinRoom.delegate = self;
        
        messageInviteView = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"短信邀请" withImageName:@"message_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:1 withItem:roomItem];
        messageInviteView.delegate = self;
        
        weixinInviteView = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"微信邀请" withImageName:@"weixin_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:2 withItem:roomItem];
        weixinInviteView.delegate = self;
        
        copyInviteView = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"拷贝链接" withImageName:@"link_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:3 withItem:roomItem];
        copyInviteView.delegate = self;
        
        SelectedItemCell *privateView = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"私密会议" withImageName:@"notification_not_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:7 withItem:roomItem];
        privateView.delegate = self;
        
        SelectedItemCell *notifications = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"通知" withImageName:@"notification_not_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:4 withItem:roomItem];
        notifications.delegate = self;
        
        SelectedItemCell *renameRoom = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"修改会议名称" withImageName:@"rename_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:5 withItem:roomItem];
        renameRoom.delegate = self;
        
        SelectedItemCell *delegateRoom = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"删除会议" withImageName:@"delegate_main" withEnableImage:nil withType:PushViewTypeSetting withIndex:6 withItem:roomItem];
        delegateRoom.delegate = self;
        
        [self.mainScrllView addSubview:joinRoom];
        [self.mainScrllView addSubview:messageInviteView];
        [self.mainScrllView addSubview:weixinInviteView];
        [self.mainScrllView addSubview:copyInviteView];
        [self.mainScrllView addSubview:privateView];
        [self.mainScrllView addSubview:notifications];
        [self.mainScrllView addSubview:renameRoom];
        [self.mainScrllView addSubview:delegateRoom];
        
        joinRoom.translatesAutoresizingMaskIntoConstraints = NO;
        messageInviteView.translatesAutoresizingMaskIntoConstraints = NO;
        weixinInviteView.translatesAutoresizingMaskIntoConstraints = NO;
        copyInviteView.translatesAutoresizingMaskIntoConstraints = NO;
        privateView.translatesAutoresizingMaskIntoConstraints = NO;
        notifications.translatesAutoresizingMaskIntoConstraints = NO;
        renameRoom.translatesAutoresizingMaskIntoConstraints = NO;
        delegateRoom.translatesAutoresizingMaskIntoConstraints = NO;
        
        // joinRoom
        NSLayoutConstraint * cons = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * cons1 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * cons2 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * cons3 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //inviteMessage
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:messageInviteView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:joinRoom attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:messageInviteView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:messageInviteView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:messageInviteView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //inviteMail
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:weixinInviteView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:messageInviteView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:weixinInviteView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:weixinInviteView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:weixinInviteView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //inviteLink
        NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:copyInviteView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weixinInviteView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:copyInviteView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:copyInviteView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:copyInviteView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //private
        NSLayoutConstraint * const1 = [NSLayoutConstraint constraintWithItem:privateView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:copyInviteView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * const2 = [NSLayoutConstraint constraintWithItem:privateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * const3 = [NSLayoutConstraint constraintWithItem:privateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * const4 = [NSLayoutConstraint constraintWithItem:privateView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //notifications
        NSLayoutConstraint * constraint12 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:privateView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint13 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint14 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint15 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //renameRoom
        NSLayoutConstraint * constraint16 = [NSLayoutConstraint constraintWithItem:renameRoom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:notifications attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint17 = [NSLayoutConstraint constraintWithItem:renameRoom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint18 = [NSLayoutConstraint constraintWithItem:renameRoom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint19 = [NSLayoutConstraint constraintWithItem:renameRoom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        //delegateRoom
        NSLayoutConstraint * constraint20 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:renameRoom attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint21 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint22 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint23 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        [self.mainScrllView addConstraint:cons];
        [self.mainScrllView addConstraint:cons1];
        [self.mainScrllView addConstraint:cons2];
        [self.mainScrllView addConstraint:cons3];
        [self.mainScrllView addConstraint:constraint];
        [self.mainScrllView addConstraint:constraint1];
        [self.mainScrllView addConstraint:constraint2];
        [self.mainScrllView addConstraint:constraint3];
        [self.mainScrllView addConstraint:constraint4];
        [self.mainScrllView addConstraint:constraint5];
        [self.mainScrllView addConstraint:constraint6];
        [self.mainScrllView addConstraint:constraint7];
        [self.mainScrllView addConstraint:constraint8];
        [self.mainScrllView addConstraint:constraint9];
        [self.mainScrllView addConstraint:constraint10];
        [self.mainScrllView addConstraint:constraint11];
        
        [self.mainScrllView addConstraint:const1];
        [self.mainScrllView addConstraint:const2];
        [self.mainScrllView addConstraint:const3];
        [self.mainScrllView addConstraint:const4];
        
        [self.mainScrllView addConstraint:constraint12];
        [self.mainScrllView addConstraint:constraint13];
        [self.mainScrllView addConstraint:constraint14];
        [self.mainScrllView addConstraint:constraint15];
        [self.mainScrllView addConstraint:constraint16];
        [self.mainScrllView addConstraint:constraint17];
        [self.mainScrllView addConstraint:constraint18];
        [self.mainScrllView addConstraint:constraint19];
        [self.mainScrllView addConstraint:constraint20];
        [self.mainScrllView addConstraint:constraint21];
        [self.mainScrllView addConstraint:constraint22];
        [self.mainScrllView addConstraint:constraint23];
    }else if (type == PushViewTypeSettingConferee){
        SelectedItemCell *joinRoom = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"进入会议" withImageName:@"enter_main" withEnableImage:nil withType:PushViewTypeSettingConferee withIndex:0 withItem:roomItem];
        joinRoom.delegate = self;
        
        SelectedItemCell *notifications = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"通知" withImageName:@"notification_not_main" withEnableImage:nil withType:PushViewTypeSettingConferee withIndex:4 withItem:roomItem];
        notifications.delegate = self;
        
        SelectedItemCell *delegateRoom = [[SelectedItemCell alloc] initWithFrame:CGRectZero withTitle:@"删除会议" withImageName:@"delegate_main" withEnableImage:nil withType:PushViewTypeSettingConferee withIndex:6 withItem:roomItem];
        delegateRoom.delegate = self;
        
        [self.mainScrllView addSubview:joinRoom];
        [self.mainScrllView addSubview:notifications];
        [self.mainScrllView addSubview:delegateRoom];
        
        joinRoom.translatesAutoresizingMaskIntoConstraints = NO;
        notifications.translatesAutoresizingMaskIntoConstraints = NO;
        delegateRoom.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        // joinRoom
        NSLayoutConstraint * cons = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * cons1 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * cons2 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * cons3 = [NSLayoutConstraint constraintWithItem:joinRoom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        //notifications
        NSLayoutConstraint * constraint12 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:joinRoom attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint13 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint14 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint15 = [NSLayoutConstraint constraintWithItem:notifications attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        
        //delegateRoom
        NSLayoutConstraint * constraint20 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:notifications attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint21 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint22 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CellHeight];
        
        NSLayoutConstraint * constraint23 = [NSLayoutConstraint constraintWithItem:delegateRoom attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
        
        [self.mainScrllView addConstraint:cons];
        [self.mainScrllView addConstraint:cons1];
        [self.mainScrllView addConstraint:cons2];
        [self.mainScrllView addConstraint:cons3];
        
        
        [self.mainScrllView addConstraint:constraint12];
        [self.mainScrllView addConstraint:constraint13];
        [self.mainScrllView addConstraint:constraint14];
        [self.mainScrllView addConstraint:constraint15];
        
        [self.mainScrllView addConstraint:constraint20];
        [self.mainScrllView addConstraint:constraint21];
        [self.mainScrllView addConstraint:constraint22];
        [self.mainScrllView addConstraint:constraint23];
    }

}

- (void)showWithType:(PushViewType)type withObject:(id)object withIndex:(NSInteger)index {
    self.index = index;
    roomItem = object;
    if (type == PushViewTypeSetting) {
          self.mainScrllView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.frame.size.height/2);
    }else{
        self.mainScrllView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.frame.size.height/4);
    }
    [self showViewOptionWithType:type];
    lastPushViewType = type;
    if (type == PushViewTypeSetting) {
        if (roomItem.mettingState == 2) {
            if (messageInviteView) {
                [messageInviteView setViewEnable:NO];
            }
            if (weixinInviteView) {
                [weixinInviteView setViewEnable:NO];
            }
            if (copyInviteView) {
                [copyInviteView setViewEnable:NO];
            }
        }
    }
    
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = ISIPAD?.9: 1;
        self.upButton.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 animations: ^{
            if (ISIPAD) {
                 self.mainScrllView.frame = CGRectMake(0, -self.bounds.size.height/4, self.bounds.size.width, self.bounds.size.height+self.bounds.size.height/4 - 50);
            }else{
                 self.mainScrllView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 50);
            }
            
             self.upButton.frame = CGRectMake(0, self.bounds.size.height - 50, self.frame.size.width, 40);
        }];
    }];

}
- (void)updateLayout
{
    UIView *shadowView = (UIView*)[self viewWithTag:401];
    CAGradientLayer *gradient = (CAGradientLayer*)[shadowView.layer.sublayers objectAtIndex:0];
    if (gradient) {
        gradient.frame = shadowView.bounds;
    }
    if (self.alpha == 0) {
        self.upButton.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, CGRectGetHeight(self.upButton.frame));
        self.mainScrllView.frame = CGRectMake(0, self.frame.size.height, self.mainScrllView.bounds.size.width, self.mainScrllView.frame.size.height);
        
    }else{
        
        if (lastPushViewType == PushViewTypeNone) {
            self.upButton.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, CGRectGetHeight(self.upButton.frame));
            self.mainScrllView.frame = CGRectMake(0, self.frame.size.height, self.mainScrllView.bounds.size.width, self.mainScrllView.frame.size.height);
        }else{
            self.upButton.frame = CGRectMake(0, self.frame.size.height-CGRectGetHeight(self.upButton.frame)-10, self.frame.size.width, CGRectGetHeight(self.upButton.frame));
            self.mainScrllView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 50);
            
            if (lastPushViewType == PushViewTypeSetting) {
                self.mainScrllView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.frame.size.height/4);
            }else{
                self.mainScrllView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            }
        }
        
    }
}

- (void)close
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.mainScrllView setFrame:CGRectMake(0, self.frame.size.height, self.bounds.size.width, self.frame.size.height)];
        self.upButton.frame = CGRectMake(0, self.bounds.size.height, self.frame.size.width, 40);
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
           
            self.alpha = 0;
            self.upButton.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.lastPushViewType = PushViewTypeNone;
            self.hidden = YES;
            // restore
            [self.mainScrllView setContentOffset:CGPointMake(0, 0) animated:NO];

        }];
    }];

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y < -1.5) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.mainScrllView setFrame:CGRectMake(0, self.frame.size.height, self.bounds.size.width, self.frame.size.height)];
            self.upButton.frame = CGRectMake(0, self.bounds.size.height, self.frame.size.width, 40);

            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.alpha = 0;
                self.upButton.alpha = 0;
                
            } completion:^(BOOL finished) {
                self.lastPushViewType = PushViewTypeNone;
                self.hidden = YES;
                // restore
                [self.mainScrllView setContentOffset:CGPointMake(0, 0) animated:NO];
            }];

        }];
    }
}

#pragma mark - SelectedItemCellDelegate

- (void)selectedItemCell:(NSInteger)index
{
    if (!delegate) {
        return;
    }
    if (lastPushViewType ==  PushViewTypeDefault) {
        [self close];
        
        if (index == 0) {
            if ([delegate respondsToSelector:@selector(pushViewInviteViaMessages:)]) {
                [delegate pushViewInviteViaMessages:roomItem];
            }
        }else if (index == 1){
            if ([delegate respondsToSelector:@selector(pushViewInviteViaWeiXin:)]) {
                [delegate pushViewInviteViaWeiXin:roomItem];
            }
        }else if (index == 2){
            if ([delegate respondsToSelector:@selector(pushViewInviteViaLink:)]) {
                [delegate pushViewInviteViaLink:roomItem];
            }
        }
        
        
    }else if (lastPushViewType == PushViewTypeSetting){
        if (index !=  4) {
            [self close];
        }
        if (index == 0) {
            if ([delegate respondsToSelector:@selector(pushViewJoinRoom:)]) {
                [delegate pushViewJoinRoom:roomItem];
            }
        }else  if (index == 1) {
            if ([delegate respondsToSelector:@selector(pushViewInviteViaMessages:)]) {
                [delegate pushViewInviteViaMessages:roomItem];
            }
        }else if (index == 2){
            if ([delegate respondsToSelector:@selector(pushViewInviteViaWeiXin:)]) {
                [delegate pushViewInviteViaWeiXin:roomItem];
            }
        }else if (index == 3){
            if ([delegate respondsToSelector:@selector(pushViewInviteViaLink:)]) {
                [delegate pushViewInviteViaLink:roomItem];
            }
        }else if (index == 5){
            if ([delegate respondsToSelector:@selector(pushViewRenameRoom:)]) {
                [delegate pushViewRenameRoom:roomItem];
            }
        }else if (index == 6){
            if ([delegate respondsToSelector:@selector(pushViewDelegateRoom:withIndex:)]) {
                [delegate pushViewDelegateRoom:roomItem withIndex:self.index];
            }
        }
    }else if (lastPushViewType == PushViewTypeSettingConferee){
          [self close];
        if (index == 0) {
            if ([delegate respondsToSelector:@selector(pushViewJoinRoom:)]) {
                [delegate pushViewJoinRoom:roomItem];
            }
        }else if (index == 6){
            if ([delegate respondsToSelector:@selector(pushViewDelegateRoom:withIndex:)]) {
                [delegate pushViewDelegateRoom:roomItem withIndex:self.index];
            }
        }
    }
}

- (void)openOrCloseNotification:(BOOL)isOpen
{
    if (roomItem) {
        if ([roomItem.canNotification isEqualToString:[[NSNumber numberWithBool:isOpen] stringValue]]) {
            return;
        }else{
            roomItem.canNotification = [[NSNumber numberWithBool:isOpen] stringValue];
            
            if ([delegate respondsToSelector:@selector(pushViewCloseOrOpenNotifications:withOpen:withIndex:)]) {
                [delegate pushViewCloseOrOpenNotifications:roomItem withOpen:isOpen withIndex:self.index];
            }
        }
      
    }
}
- (void)privateMeeting:(BOOL)isPrivate
{
    if (isPrivate) {
        if (messageInviteView) {
            [messageInviteView setViewEnable:NO];
        }
        if (weixinInviteView) {
            [weixinInviteView setViewEnable:NO];
        }
        if (copyInviteView) {
            [copyInviteView setViewEnable:NO];
        }
        if (roomItem.mettingState ==2) {
            return;
        }
        roomItem.mettingState = 2;
        if ([delegate respondsToSelector:@selector(pushViewPrivateMeeting:withPrivate:withIndex:)]) {
            [delegate pushViewPrivateMeeting:roomItem withPrivate:YES withIndex:self.index];
        }
        
    }else{
        if (messageInviteView) {
            [messageInviteView setViewEnable:YES];
        }
        if (weixinInviteView) {
            [weixinInviteView setViewEnable:YES];
        }
        if (copyInviteView) {
            [copyInviteView setViewEnable:YES];
        }
        roomItem.mettingState = 1;
        if ([delegate respondsToSelector:@selector(pushViewPrivateMeeting:withPrivate:withIndex:)]) {
            [delegate pushViewPrivateMeeting:roomItem withPrivate:NO withIndex:self.index];
        }
    }
}

@end
