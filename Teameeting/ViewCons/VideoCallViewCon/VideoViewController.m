//
//  VideoViewController.m
//  Teameeting
//
//  Created by zjq on 16/1/21.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "VideoViewController.h"
#import "LockerView.h"
#import "RootViewController.h"
#import "DXPopover.h"
#import "ReceiveCallViewController.h"
#import "TMMessageManage.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "ASHUD.h"
#import "TransitionDelegate.h"
#import "ToolUtils.h"
#import "SvUDIDTools.h"

@implementation UINavigationController (Orientations)


- (NSUInteger)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

@end

@interface VideoViewController ()<UIGestureRecognizerDelegate,LockerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    UITapGestureRecognizer *tapGesture;
    dispatch_source_t _calltimer;

}
@property (nonatomic, strong) LockerView *menuView;
@property (nonatomic, strong) RootViewController *rootView;
@property (nonatomic, strong) UIImageView *micStateImage;
@property (nonatomic, strong) DXPopover *popver;
@property (nonatomic, strong) ReceiveCallViewController *callViewCon;
@property (nonatomic, strong) UILabel *noUserTip;

@property (nonatomic, assign) BOOL isChat;
@property (nonatomic, strong) UINavigationController *talkNav;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, strong) TransitionDelegate *transDelegate;

@property (nonatomic, strong) UIButton *callButton;
@end

@implementation VideoViewController

- (void)dealloc
{
    [ToolUtils shead].roomID = nil;
    if (_calltimer) {
        dispatch_source_cancel(_calltimer);
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar rm_setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[TMMessageManage sharedManager] tmRoomCmd:MCMeetCmdENTER roomid:self.roomItem.roomID withRoomName:self.roomItem.roomName remain:@""];
    self.navigationController.delegate = self;
    self.title = self.roomItem.roomName;
    [ToolUtils shead].roomID = self.roomItem.roomID;
    
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openVideo) name:OPENVIDEO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteVideoChange:) name:@"REMOTEVIDEOCHANGE" object:nil];
    
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(0, 0, 28, 28);
    [chatButton setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    chatButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [chatButton addTarget:self action:@selector(goToChat:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *groupButton =[[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.leftBarButtonItem = groupButton;
    
    self.badgeView = [[ASBadgeView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    self.badgeView .horizontalAlignment = ASBadgeViewHorizontalAlignmentRight;
    self.badgeView .alignmentShift = CGSizeMake(-8, 6);
    self.badgeView .badgeBackgroundColor =  [UIColor redColor];
    self.badgeView .verticalAlignment = ASBadgeViewVerticalAlignmentTop;
    [self.badgeView  setFont:[UIFont systemFontOfSize:14]];
    [chatButton addSubview:self.badgeView ];
    
//    if (self.roomItem.mettingState != 2) {
//        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//        [shareButton addTarget:self action:@selector(shareView) forControlEvents:UIControlEventTouchUpInside];
//        shareButton.frame = CGRectMake(0, 0, 28, 28);
//        UIBarButtonItem *groupButton1 =[[UIBarButtonItem alloc] initWithCustomView:shareButton];
//        self.navigationItem.rightBarButtonItems = @[groupButton1];
//    }
    
    if (self.roomItem.mettingState != 2) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareView) forControlEvents:UIControlEventTouchUpInside];
        shareButton.frame = CGRectMake(0, 0, 28, 28);
        UIBarButtonItem *groupButton1 =[[UIBarButtonItem alloc] initWithCustomView:shareButton];
        if ([self.roomItem.userID isEqualToString:[SvUDIDTools shead].UUID]) {
            self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.callButton setImage:[UIImage imageNamed:@"btn_reminder"] forState:UIControlStateNormal];
            [self.callButton addTarget:self action:@selector(callOthers) forControlEvents:UIControlEventTouchUpInside];
            self.callButton.frame = CGRectMake(0, 0, 30, 28);
            UIBarButtonItem *groupButton2 =[[UIBarButtonItem alloc] initWithCustomView:self.callButton];
            self.navigationItem.rightBarButtonItems = @[groupButton1,groupButton2];
        }else{
            self.navigationItem.rightBarButtonItems = @[groupButton1];
        }
        
    }else{
        if ([self.roomItem.userID isEqualToString:[SvUDIDTools shead].UUID]) {
            self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.callButton setImage:[UIImage imageNamed:@"btn_reminder"] forState:UIControlStateNormal];
            [self.callButton addTarget:self action:@selector(callOthers) forControlEvents:UIControlEventTouchUpInside];
            self.callButton.frame = CGRectMake(0, 0, 30, 28);
            UIBarButtonItem *groupButton2 =[[UIBarButtonItem alloc] initWithCustomView:self.callButton];
            self.navigationItem.rightBarButtonItem = groupButton2;
        }
        
    }

    
    self.callViewCon = [[ReceiveCallViewController alloc] init];
    __weak VideoViewController *weakSelf = self;
    [self.callViewCon setDisMissPar:^{
         [weakSelf dismiss];
    }];
    
    self.callViewCon.roomItem = self.roomItem;
    self.callViewCon.videoController = self;
    self.menuView = [[LockerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, 300, 60)];
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - self.menuView.bounds.size.height)];
    self.menuView.delegate = self;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tapGesture.delegate = self;
    tapGesture.enabled = NO;
    [self.view addGestureRecognizer:tapGesture];
    if (ISIPAD) {
        
        UISwipeGestureRecognizer *leftswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        leftswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:leftswipeGestureRecognizer];
        
        UISwipeGestureRecognizer *rightswipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        rightswipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightswipeGestureRecognizer];
        
    }else{
         _transDelegate = [[TransitionDelegate alloc] init];
    }
    self.noUserTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 80, 50)];
    [self.noUserTip setUserInteractionEnabled:NO];
    self.noUserTip.shadowColor = [UIColor blackColor];
    self.noUserTip.shadowOffset = CGSizeMake(0, -0.5);
    [self.noUserTip setTextColor:[UIColor whiteColor]];
    [self.noUserTip setNumberOfLines:0];
    self.noUserTip.font = [UIFont boldSystemFontOfSize:18];
    [self.noUserTip setTextAlignment:NSTextAlignmentCenter];
    self.noUserTip.text = @"等待别人进入房间";
    [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, CGRectGetMinY(self.menuView.frame) - CGRectGetHeight(self.noUserTip.frame))];
    self.callViewCon.view.frame = self.view.bounds;
    [self.view addSubview:self.callViewCon.view];
    [self.view addSubview:self.noUserTip];
     [self.view addSubview:self.menuView];
    [self performSelector:@selector(loadTableView) withObject:nil afterDelay:0.1];
    
    // check out no read messages
    NSDictionary *dict = [[TMMessageManage sharedManager] getUnreadCountByRoomKeys:self.roomItem.roomID,nil];
    NSArray *array = [dict objectForKey:self.roomItem.roomID];
    if (array.count>1) {
        self.badgeView.text = [[array objectAtIndex:0] stringValue];
    }else{
        self.badgeView.text = @"0";
    }
   
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat rootViewWidth = TalkPannelWidth;//isVertical == YES ? (self.view.bounds.size.width/2 - 50) : (self.view.bounds.size.width/2 - 150);
    if (!self.rootView) {
        return;
    }
    if (ISIPAD) {
        if (self.rootView.view.frame.origin.x < 0) {
            
            [self.rootView.view setFrame:CGRectMake(0 - rootViewWidth, 0, rootViewWidth, self.view.bounds.size.height)];
            [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - self.menuView.bounds.size.height)];
            [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, CGRectGetMinY(self.menuView.frame) - self.noUserTip.bounds.size.height)];
            
        } else {
            
            [self.rootView.view setFrame:CGRectMake(0, 0, rootViewWidth, self.view.bounds.size.height)];
            [self.menuView setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2+TalkPannelWidth, self.view.bounds.size.height - self.menuView.bounds.size.height)];
            [self.noUserTip setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2+TalkPannelWidth, CGRectGetMinY(self.menuView.frame) - self.noUserTip.bounds.size.height)];
        }
    } else {
        if (self.isChat) {
            [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height + self.menuView.bounds.size.height))];
            [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2,(self.view.bounds.size.height - 90))];
            [self.rootView.view setFrame:self.view.bounds];
        }else{
            [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.isFullScreen == YES ? (self.view.bounds.size.height + self.menuView.bounds.size.height) : (self.view.bounds.size.height - self.menuView.bounds.size.height))];
            [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, self.isFullScreen == YES ? (self.view.bounds.size.height + self.noUserTip.bounds.size.height) : (CGRectGetMinY(self.menuView.frame) - self.noUserTip.bounds.size.height/2))];
            [self.rootView.view setFrame:self.view.bounds];
        }
       
    }
    if (self.view.bounds.size.width>self.view.bounds.size.height) {
    
        if (!self.isFullScreen) {
            if (!ISIPAD) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            }
        }
    }else{
        if (!self.isFullScreen) {
            if (!ISIPAD) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            }
        }
    }
   
}

- (BOOL)isVertical {
    
    BOOL isVertical = YES;
    NSUInteger width = self.view.bounds.size.width;
    NSUInteger height = self.view.bounds.size.height;
    isVertical = width > height ? NO : YES;
    return isVertical;
}

- (void)openOrCloseTalk:(BOOL)isOpen
{
    if (isOpen) {
        if (self.isChat) {
            return;
        }else{
            [self goToChat:nil];
        }
    }else{
        if (self.isChat) {
            [self.rootView closeChatView];
        }
    }
}
- (void)dismissMyself
{
    if (self.talkNav) {
        [self.talkNav dismissViewControllerAnimated:NO completion:nil];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.callViewCon) {
            [self.callViewCon hangeUp];
            [[TMMessageManage sharedManager] removeMessageListener:self.rootView];
        }
        if (self.DismissVideoViewController) {
            self.DismissVideoViewController();
        }
    }];

}

- (void)loadTableView {
    
    CGFloat rootViewWidth = TalkPannelWidth;//isVertical == YES ? (self.view.bounds.size.width/2 - 50) : (self.view.bounds.size.width/2 - 150);
    self.rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.rootView.parentViewCon = self;
    self.rootView.view.autoresizingMask = UIViewAutoresizingNone;
    self.rootView.view.backgroundColor = [UIColor clearColor];
    if (ISIPAD) {
        self.rootView.view.frame = CGRectMake(0 - rootViewWidth, 0, rootViewWidth, self.view.bounds.size.height);
          [self.view addSubview:self.rootView.view];
    }else{
        self.talkNav = [[UINavigationController alloc] initWithRootViewController:_rootView];
        self.rootView.title = @"聊天";
        __weak VideoViewController *weakSelf = self;
        [_rootView setCloseRootViewBlock:^{
            weakSelf.isChat = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.menuView setCenter:CGPointMake(weakSelf.menuView.center.x,  (weakSelf.view.bounds.size.height - weakSelf.menuView.bounds.size.height))];
                
                [weakSelf.noUserTip setCenter:CGPointMake(weakSelf.view.bounds.size.width/2, (CGRectGetMinY(weakSelf.menuView.frame) - weakSelf.noUserTip.bounds.size.height))];
            } completion:^(BOOL finished) {
                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TALKCHAT_NOTIFICATION" object:[NSNumber numberWithBool:NO]];
            //weakSelf.talkNav.view.hidden = YES;
            [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
            [weakSelf.rootView resginKeyBord];
            [weakSelf.rootView setReceiveMessageEnable:NO];
            [[TMMessageManage sharedManager] removeMessageListener:weakSelf.rootView];
            // 继续初始化talkNav
            [weakSelf initTalkNav];
        }];
    }
  
}
- (void)initTalkNav
{
    if (self.talkNav) {
        self.talkNav = nil;
    }
    if (self.rootView) {
        self.rootView = nil;
    }
    self.rootView = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    self.rootView.parentViewCon = self;
    self.rootView.view.autoresizingMask = UIViewAutoresizingNone;
    self.rootView.view.backgroundColor = [UIColor clearColor];
    self.talkNav = [[UINavigationController alloc] initWithRootViewController:_rootView];
    __weak VideoViewController *weakSelf = self;
    [_rootView setCloseRootViewBlock:^{
        weakSelf.isChat = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.menuView setCenter:CGPointMake(weakSelf.menuView.center.x, (weakSelf.view.bounds.size.height - weakSelf.menuView.bounds.size.height))];
            
            [weakSelf.noUserTip setCenter:CGPointMake(weakSelf.view.bounds.size.width/2,  (CGRectGetMinY(weakSelf.menuView.frame) - weakSelf.noUserTip.bounds.size.height))];
        } completion:^(BOOL finished) {
            
        }];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"TALKCHAT_NOTIFICATION" object:[NSNumber numberWithBool:NO]];
        //weakSelf.talkNav.view.hidden = YES;
//        [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
        
        [weakSelf.rootView resginKeyBord];
        [weakSelf.rootView setReceiveMessageEnable:NO];
        // 继续初始化talkNav
        [weakSelf initTalkNav];
        
    }];
}
- (void)remoteVideoChange:(NSNotification *)noti {
    
    NSNumber *object = [noti object];
    NSInteger remoteCount = [object integerValue];
    if (remoteCount > 0) {
        tapGesture.enabled = YES;
        [self.noUserTip setHidden:YES];
        
    } else {
        tapGesture.enabled = NO;
        [self.noUserTip setHidden:NO];
        
        self.isFullScreen = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.menuView setCenter:CGPointMake(self.menuView.center.x, (self.view.bounds.size.height - self.menuView.bounds.size.height))];
            
            [self.noUserTip setCenter:CGPointMake(self.noUserTip.center.x, (CGRectGetMinY(self.menuView.frame) - self.noUserTip.bounds.size.height))];
            
        }completion:^(BOOL finished) {
        }];
        
    }
}

- (void)openVideo {
    
    [self.callViewCon videoEnable:YES];
}

#pragma mark - button event
- (void)shareView {
    if (self.popver) {
        [self.popver dismiss];
        self.popver = nil;
        return;
    }
    BOOL isVertical = YES;
    NSUInteger width = self.view.bounds.size.width;
    NSUInteger height = self.view.bounds.size.height;
    isVertical = width > height ? NO : YES;
    
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = [UIColor colorWithRed:205.f/255.f green:205.f/255.f blue:203.f/255.f alpha:1];
    if (ISIPAD) {
        
        if (isVertical) {
            
            shareView.frame = CGRectMake(0, 0, 300, 400);
        } else {
            
            shareView.frame = CGRectMake(0, 0, 400, 300);
        }
        
    } else {
        
        if (!isVertical) {
            
            shareView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 30, self.view.bounds.size.height - 66);
            
        } else {
            
            shareView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 30, 400);
        }
        
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:19],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.bounds.size.width-40, 60)];
    title.attributedText = [[NSAttributedString alloc] initWithString:@"你想通过那种方式邀请好友？" attributes:attributes];
    title.autoresizingMask = UIViewContentModeBottom;
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor blackColor]];
    [title setNumberOfLines:0];
    [shareView addSubview:title];
    
    UIButton *messageImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [messageImage addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageImage setBackgroundImage:[UIImage imageNamed:@"messageInvite"] forState:UIControlStateNormal];
    messageImage.backgroundColor = [UIColor clearColor];
    [shareView addSubview:messageImage];
    
    UIButton *mailImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [mailImage setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [mailImage addTarget:self action:@selector(weChatShare) forControlEvents:UIControlEventTouchUpInside];
    mailImage.backgroundColor = [UIColor clearColor];
    [shareView addSubview:mailImage];
    
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharebackgroud"]];
    bottomBar.autoresizingMask = UIViewContentModeBottom;
    bottomBar.backgroundColor = [UIColor clearColor];
    [shareView addSubview:bottomBar];
    
    UILabel *messageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [messageTitle setFont:[UIFont systemFontOfSize:12]];
    messageTitle.text = @"短信";
    [messageTitle setTextColor:[UIColor blackColor]];
    [messageTitle setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *mailTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [mailTitle setFont:[UIFont systemFontOfSize:12]];
    mailTitle.text = @"微信";
    [mailTitle setTextColor:[UIColor blackColor]];
    [mailTitle setTextAlignment:NSTextAlignmentCenter];
    [shareView addSubview:messageTitle];
    [shareView addSubview:mailTitle];
    
    
    UILabel *descriptionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.bounds.size.width - 40, 80)];
    
    descriptionTitle.attributedText = [[NSAttributedString alloc] initWithString:@"你也可以拷贝连接，发送给好友来进行邀请。" attributes:attributes];
    [descriptionTitle setFont:[UIFont systemFontOfSize:17]];
    [descriptionTitle setNumberOfLines:0];
    [descriptionTitle setTextColor:[UIColor grayColor]];
    [descriptionTitle setTextAlignment:NSTextAlignmentCenter];
    [descriptionTitle setBackgroundColor:[UIColor clearColor]];
    [shareView addSubview:descriptionTitle];
    
    UILabel *linkTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [linkTitle setFrame:CGRectMake(0, 0, shareView.bounds.size.width - (isVertical ? 60 : 80), (isVertical ? 56 : 45))];
    linkTitle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [linkTitle setFont:[UIFont systemFontOfSize:14]];
    linkTitle.text = [NSString stringWithFormat:@"%@#/%@",ShearUrl,self.roomItem.roomID];
    [linkTitle setTextColor:[UIColor grayColor]];
    [linkTitle setBackgroundColor:[UIColor clearColor]];
    [linkTitle setTextAlignment:NSTextAlignmentCenter];
    [shareView addSubview:linkTitle];
    
    UIButton *copyLink = [[UIButton alloc] init];
    [copyLink setTitle:@"拷贝" forState:UIControlStateNormal];
    [copyLink addTarget:self action:@selector(copyLineButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [copyLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyLink setBackgroundColor:[UIColor blackColor]];
    [shareView addSubview:copyLink];
    
    if (!isVertical) {
        
        [title setCenter:CGPointMake(shareView.bounds.size.width/2, 40)];
        messageImage.center = CGPointMake(shareView.bounds.size.width/2 - 40, CGRectGetMaxY(title.frame) + 30);
        mailImage.center = CGPointMake(shareView.bounds.size.width/2 + 40, CGRectGetMaxY(title.frame) + 30);
        bottomBar.frame = CGRectMake(0, shareView.bounds.size.height - 45, shareView.bounds.size.width-80, 45);
        [messageTitle setCenter:CGPointMake(messageImage.center.x, CGRectGetMaxY(messageImage.frame) + 15)];
        [mailTitle setCenter:CGPointMake(mailImage.center.x, CGRectGetMaxY(mailImage.frame) + 15)];
        [descriptionTitle setCenter:CGPointMake(shareView.bounds.size.width/2, CGRectGetMaxY(mailTitle.frame) + 45)];
        [linkTitle setFrame:CGRectMake(0, shareView.bounds.size.height- linkTitle.bounds.size.height,linkTitle.bounds.size.width, linkTitle.bounds.size.height)];
        [copyLink setFrame:CGRectMake(CGRectGetMaxX(linkTitle.frame),CGRectGetHeight(shareView.frame)-45, shareView.bounds.size.width - CGRectGetMaxX(linkTitle.frame), 45)];
        
    }  else {
        
        [title setCenter:CGPointMake(shareView.bounds.size.width/2, 60)];
        messageImage.center = CGPointMake(shareView.bounds.size.width/2 - 40, CGRectGetMaxY(title.frame) + 50);
        mailImage.center = CGPointMake(shareView.bounds.size.width/2 + 40, CGRectGetMaxY(title.frame) + 50);
        bottomBar.frame = CGRectMake(0, shareView.bounds.size.height - 56, shareView.bounds.size.width -60, 56);
        [messageTitle setCenter:CGPointMake(messageImage.center.x, CGRectGetMaxY(messageImage.frame) + 15)];
        [mailTitle setCenter:CGPointMake(mailImage.center.x, CGRectGetMaxY(mailImage.frame) + 15)];
        [descriptionTitle setCenter:CGPointMake(shareView.bounds.size.width/2, CGRectGetMaxY(mailTitle.frame) + 55)];
        [linkTitle setFrame:CGRectMake(0, shareView.bounds.size.height- linkTitle.bounds.size.height,linkTitle.bounds.size.width, linkTitle.bounds.size.height)];
        [copyLink setFrame:CGRectMake(CGRectGetMaxX(linkTitle.frame), CGRectGetHeight(shareView.frame)-56, shareView.bounds.size.width - CGRectGetMaxX(linkTitle.frame), 56)];
        
    }
    if (self.popver) {
        
        [self.popver dismiss];
        self.popver = nil;
    }
    self.popver = [DXPopover popover];
    self.popver.sideEdge = 15;
    self.popver.arrowSize = CGSizeMake(15, 15);
    
    CGPoint startPoint;
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
         startPoint = CGPointMake(self.view.bounds.size.width - 25, CGRectGetHeight(self.navigationController.navigationBar.bounds)+5);
    }else{
        startPoint = CGPointMake(self.view.bounds.size.width - 25, CGRectGetHeight(self.navigationController.navigationBar.bounds)+25);
    }
   
      [self.popver showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:shareView inView:self.navigationController.view];
}


- (void)goToChat:(UIButton *)button {
    
    self.isChat = YES;
    if (ISIPAD) {
        if (self.rootView.view.frame.origin.x<0) {
            [self.callViewCon transitionVideoView:YES];
        }else{
            [self.callViewCon transitionVideoView:NO];
        }
        [UIView animateWithDuration:0.2 animations:^{
            
            if (self.rootView.view.frame.origin.x < 0) {
                
                [self.rootView.view setFrame:CGRectMake(0,self.rootView.view.frame.origin.y, self.rootView.view.bounds.size.width, self.rootView.view.bounds.size.height)];
                [self.menuView setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2+TalkPannelWidth, self.menuView.center.y)];
                [self.noUserTip setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2+TalkPannelWidth, self.noUserTip.center.y)];
                [self.rootView setReceiveMessageEnable:YES];
                
            } else {
                
                [self.rootView.view setFrame:CGRectMake(0 - self.rootView.view.bounds.size.width,self.rootView.view.frame.origin.y, self.rootView.view.bounds.size.width, self.rootView.view.bounds.size.height)];
                [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.menuView.center.y)];
                [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, self.noUserTip.center.y)];
                [self.rootView setReceiveMessageEnable:NO];
            }
            
        }];
        
    } else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            [self.talkNav setTransitioningDelegate:self.transDelegate];
            self.talkNav.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:self.talkNav animated:NO completion:nil];
        }
        else
        {
            self.rootView.view.backgroundColor = [UIColor clearColor];
            self.talkNav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:self.talkNav animated:NO completion:nil];
        }
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.menuView setCenter:CGPointMake(self.menuView.center.x, (self.view.bounds.size.height + self.menuView.bounds.size.height))];
            
            [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2,  (self.view.bounds.size.height -90))];
        }];
        [self.rootView setReceiveMessageEnable:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TALKCHAT_NOTIFICATION" object:[NSNumber numberWithBool:YES]];
    }
}

- (void)callOthers
{
    self.callButton.enabled = NO;
    [[TMMessageManage sharedManager] tMNotifyMsgRoomid:_roomItem.roomID withRoomName:_roomItem.roomName withTags:MCSendTagsCALL withMessage:[NSString stringWithFormat:@"喊你进\"%@\"房间啦!",_roomItem.roomName]];
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"喊别人进房间啦！" icon:@"btn_reminder"];
    [self startCallTime];
}

- (void)startCallTime
{
    __block int timeout = 30; //倒计时时间
    __block UIButton *getcallButton = self.callButton;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _calltimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_calltimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_calltimer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_calltimer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                getcallButton.enabled = YES;
                
            });
            
        }else{
            timeout--;
            
        }
    });
    dispatch_resume(_calltimer);
}


#pragma mark - UISwipeGestureRecognizer method
- (void)handleSwipes:(UISwipeGestureRecognizer*)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"left");
            if (self.rootView.view.frame.origin.x>=0) {
                self.isChat = NO;
                [self.callViewCon transitionVideoView:NO];
                [UIView animateWithDuration:0.2 animations:^{
                    CGFloat rootViewWidth =TalkPannelWidth;// [self isVertical] == YES ? (self.view.bounds.size.width/2 - 50) : (self.view.bounds.size.width/2 - 150);

                    [self.rootView.view setFrame:CGRectMake(0 - rootViewWidth,self.rootView.view.frame.origin.y, self.rootView.view.bounds.size.width, self.rootView.view.bounds.size.height)];
                    [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.menuView.center.y)];
                    [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, self.noUserTip.center.y)];
                }completion:^(BOOL finished) {
                    [self.rootView setReceiveMessageEnable:NO];
                }];
                [self.rootView resginKeyBord];
                
            }
            break;
          
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"right");
            if (self.rootView.view.frame.origin.x<0) {
                self.isChat = YES;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.callViewCon transitionVideoView:YES];

                [UIView animateWithDuration:0.2 animations:^{
                    
                    [self.rootView.view setFrame:CGRectMake(0,self.rootView.view.frame.origin.y, self.rootView.view.bounds.size.width, self.rootView.view.bounds.size.height)];
                    [self.menuView setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2 +TalkPannelWidth, self.menuView.center.y)];
                    [self.noUserTip setCenter:CGPointMake((self.view.bounds.size.width - TalkPannelWidth)/2+TalkPannelWidth, self.noUserTip.center.y)];
                }completion:^(BOOL finished) {
                    [self.rootView setReceiveMessageEnable:YES];
                }];

            }
            break;
            
        default:
            break;
    }
}

- (void)tapEvent:(UITapGestureRecognizer*)tap{
    
    if (self.popver) {
        
        [self.popver dismiss];
        self.popver = nil;
        return;
    }
 
    if (self.isChat) {
        if (self.rootView.view.frame.origin.x>=0) {
            self.isChat = NO;
            [self.callViewCon transitionVideoView:NO];
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat rootViewWidth = TalkPannelWidth;// [self isVertical] == YES ? (self.view.bounds.size.width/2 - 50) : (self.view.bounds.size.width/2 - 150);
                
                [self.rootView.view setFrame:CGRectMake(0 - rootViewWidth,self.rootView.view.frame.origin.y, self.rootView.view.bounds.size.width, self.rootView.view.bounds.size.height)];
                [self.menuView setCenter:CGPointMake(self.view.bounds.size.width/2, self.menuView.center.y)];
                [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, self.noUserTip.center.y)];
            }completion:^(BOOL finished) {
                [self.rootView setReceiveMessageEnable:NO];
            }];
            [self.rootView resginKeyBord];
            
        }
    }else{
       
        if (ISIPAD) {
             self.isFullScreen = !self.isFullScreen;
            if (self.isFullScreen) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                [self.navigationController setNavigationBarHidden:YES animated:YES];
            }else{
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        }else{
            if (self.view.frame.size.width>self.view.frame.size.height) {
                self.isFullScreen = !self.isFullScreen;
                if (self.isFullScreen) {
                    [self.navigationController setNavigationBarHidden:YES animated:YES];
                }else{
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                }
            }else{
                self.isFullScreen = !self.isFullScreen;
                if (self.isFullScreen) {
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                    [self.navigationController setNavigationBarHidden:YES animated:NO];
                }else{
                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                    [self.navigationController setNavigationBarHidden:NO animated:NO];
                }
            }
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.menuView setCenter:CGPointMake(self.menuView.center.x, self.isFullScreen == YES ? (self.view.bounds.size.height + self.menuView.bounds.size.height) : (self.view.bounds.size.height - self.menuView.bounds.size.height))];
            
            [self.noUserTip setCenter:CGPointMake(self.view.bounds.size.width/2, self.isFullScreen == YES ? (self.view.bounds.size.height + self.noUserTip.bounds.size.height) : (CGRectGetMinY(self.menuView.frame) - self.noUserTip.bounds.size.height))];
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FULLSCREEN" object:[NSNumber numberWithBool:self.isFullScreen]];
    }
}
#pragma mark - share methods
- (void)weChatShare {
    
    [_popver dismiss];
    if ([WXApi isWXAppInstalled]) {
        //判断是否有微信
        [WXApiRequestHandler sendLinkURL:[NSString stringWithFormat:@"%@#/%@",ShearUrl,self.roomItem.roomID]
                                 TagName:nil
                                   Title:@"Teameeting"
                             Description:@"视频邀请"
                              ThumbImage:[UIImage imageNamed:@"Icon-1"]
                                 InScene:WXSceneSession];
    }else{
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该设备没有安装微信" icon:nil];
    }
    
}

- (void)sendMessage {
    
    [_popver dismiss];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate =self;
            NSString *smsBody =[NSString stringWithFormat:@"让我们在会议中见!👉 %@#/%@",ShearUrl,self.roomItem.roomID];
            
            picker.body=smsBody;
            
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
        else {
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该设备不支持短信功能" icon:nil];
        }
        
    }
    
}
// copy line method
- (void)copyLineButtonEvent:(UIButton*)button
{
    [_popver dismiss];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@#/%@",ShearUrl,self.roomItem.roomID];
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"拷贝成功" icon:@"copy_scuess"];
}

#pragma mark - LockerDelegate
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.callViewCon) {
            [self.callViewCon hangeUp];
            [[TMMessageManage sharedManager] removeMessageListener:self.rootView];
        }
        if (self.DismissVideoViewController) {
            self.DismissVideoViewController();
        }
    }];
}
- (void)menuClick:(LockerButton *)item
{
    if (item.tag == 10) {
        [self dismiss];
        
    } else if (item.tag == 20) {
        
        item.isSelect = !item.isSelect;
        if (self.callViewCon) {
            [self.callViewCon audioEnable:!item.isSelect];
        }
        if (!item.isSelect) {
            
            [self.micStateImage setHidden:YES];
            [item setBackgroundImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageNamed:@"micselect"] forState:UIControlStateHighlighted];
            
        } else {
            
            [self.micStateImage setHidden:NO];
            [item setBackgroundImage:[UIImage imageNamed:@"noMic"] forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageNamed:@"noMicselect"] forState:UIControlStateHighlighted];
        }
    }else if(item.tag == 30){
        
        if (self.callViewCon) {
            [self.callViewCon switchCamera];
        }
        
    }else if (item.tag == 40){
        
        item.isSelect = !item.isSelect;
        if (self.callViewCon) {
            [self.callViewCon videoEnable:!item.isSelect];
        }
        [self.menuView showEnable:YES];
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [self.navigationController.navigationBar setTranslucent:YES];
        //main_line@2x
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:0.1];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gestureRecognizer:%@",touch.view);
    Class class = NSClassFromString(@"UITableViewCellContentView");
    if(touch.view.superview != self.rootView.view && ![touch.view isKindOfClass:class]){
        return YES;
    }else
        return NO;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.popver) {
        [self.popver dismiss];
        self.popver = nil;
    }
}


//NS_AVAILABLE_IOS(8_0);
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         if (self.popver) {
             [self.popver dismiss];
             self.popver = nil;
         }
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         if (self.callViewCon) {
             [self.callViewCon layoutSubView];
         }
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
