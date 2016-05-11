//
//  MainViewController.m
//  Room
//
//  Created by yangyang on 15/11/16.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "MainViewController.h"
#import "PushView.h"
#import "RoomViewCell.h"

#import "GetRoomView.h"

#import "ServerVisit.h"
#import "SvUDIDTools.h"
#import "ToolUtils.h"
#import "ASHUD.h"
#import <MessageUI/MessageUI.h>
#import "ASNetwork.h"
#import "RoomAlertView.h"
#import "NavView.h"
#import "NtreatedDataManage.h"
#import "UIView+Category.h"
#import "AppDelegate.h"
#import "NtreatedDataManage.h"

#import "EmptyViewFactory.h"
#import "EnterMeetingIDViewController.h"
#import "UIImage+Category.h"
#import "TMMessageManage.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "SpotlightManager.h"


static NSString *kRoomCellID = @"RoomCell";

#define IPADLISTWIDTH 320

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,RoomViewCellDelegate,GetRoomViewDelegate,PushViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,tmMessageReceive,RoomAlertViewDelegate>

{
    RoomItem *tempRoomItem;
}

@property (nonatomic, strong) UIButton *getRoomButton;
@property (nonatomic, strong) PushView *push;
@property (nonatomic, strong) GetRoomView *getRoomView;

@property (nonatomic, strong) NSMutableArray *tempDataArray; // temp data
@property (nonatomic, strong) UIButton *cancleButton;    // cancle create room button
@property (nonatomic, strong) UIButton *inputButton;
@property (nonatomic, strong) RoomAlertView *netAlertView;
@property (nonatomic, strong) RoomAlertView *reNameAlertView;
@property (nonatomic, strong) NavView *navView;
@property (nonatomic, assign) UIInterfaceOrientation oldInterface;
@property (nonatomic, strong) UIImageView *listBgView;
@property (nonatomic, strong) UIView *bgView;


@end

@implementation MainViewController
@synthesize dataArray;
@synthesize tempDataArray;

- (void)dealloc
{
    [[ASNetwork sharedNetwork] removeObserver:self forKeyPath:@"_netType" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.dataArray.count!=0) {
        [self getNotReadMessageNum];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[TMMessageManage sharedManager] registerMessageListener:self];
    
    self.oldInterface = self.interfaceOrientation;
    self.view.backgroundColor = [UIColor clearColor];
    
    [[ASNetwork sharedNetwork] addObserver:self forKeyPath:@"_netType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] initWithCapacity:5];
        tempDataArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [self initUser];
    [self setBackGroundImageView];
    
    self.listBgView = [UIImageView new];
    self.listBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.listBgView];
    
    self.navView = [NavView new];
    self.navView.title = @"房间";
    [self.view addSubview:self.navView];

    
    self.roomList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.roomList.backgroundColor = [UIColor clearColor];
    self.roomList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.roomList.delegate = self;
    self.roomList.dataSource = self;
    [self.view addSubview:self.roomList];
    [self.roomList registerClass:[RoomViewCell class] forCellReuseIdentifier:kRoomCellID];
    
    self.getRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getRoomButton setTitle:@"创建房间" forState:UIControlStateNormal];
    [self.getRoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getRoomButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:self.getRoomButton];
    [self.getRoomButton addTarget:self action:@selector(getRoomButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.getRoomButton setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:156.0/255.0 blue:55.0/255.0 alpha:1.0]];
    self.getRoomButton.layer.cornerRadius = 2;
    
    
    
    self.getRoomView = [[GetRoomView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, CGRectGetHeight(self.view.frame)) withParView:self.view];
    self.getRoomView.delegate = self;
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.frame = CGRectMake(15, 25, 35, 28);
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.cancleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.cancleButton addTarget:self action:@selector(cancleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.cancleButton];
    self.cancleButton.hidden = YES;
    
    self.inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inputButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.inputButton addTarget:self action:@selector(inputButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.inputButton];
    
    if (ISIPAD) {
        self.listBgView.frame = CGRectMake(0, 0, IPADLISTWIDTH, CGRectGetHeight(self.view.frame));
        
        self.navView.frame = CGRectMake(0, 0, IPADLISTWIDTH, 64);
        self.roomList.frame = CGRectMake(0, 64, IPADLISTWIDTH,CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.navView.frame) -75);
        self.getRoomButton.frame = CGRectMake(15, CGRectGetMaxY(self.view.frame) - 60,IPADLISTWIDTH -30, 45);
        
    }else{
        self.listBgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, CGRectGetHeight(self.view.frame));
        
        self.navView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
        self.roomList.frame = CGRectMake(0, 64, self.view.bounds.size.width,CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.navView.frame) -75);
        self.getRoomButton.frame = CGRectMake(15, CGRectGetMaxY(self.view.frame) - 60,self.view.bounds.size.width -30, 45);

    }
    self.inputButton.frame = CGRectMake(CGRectGetWidth(self.navView.frame)-40, 30, 30, 30);
    
    self.push = [[PushView alloc] initWithFrame:self.view.bounds];
    self.push.delegate = self;
    AppDelegate *apple = [RoomApp shead].appDelgate;
    [apple.window.rootViewController.view addSubview:self.push];
    
    [self.view bringSubviewToFront:self.navView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareMettingNotification:) name:ShareMettingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterNotification:) name:NotificationEntNotification object:nil];
    
}
// 旋转屏幕适配
- (void)viewDidLayoutSubviews
{
     [self refreshImage];
    if (ISIPAD) {
        if (self.netAlertView) {
            [self.netAlertView updateFrame];
        }
        if (self.reNameAlertView) {
            [self.reNameAlertView updateFrame];
        }
    }
    if (self.oldInterface == self.interfaceOrientation || !ISIPAD) {
        return;
    }else{
         UIView *initView = [[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:400];
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            if (initView) {
                initView.frame = [UIScreen mainScreen].bounds;
                UIImageView *bg = [initView viewWithTag:401];
                bg.image = [self getLaunchImage];
            }
            self.listBgView.frame = CGRectMake(0, 0, IPADLISTWIDTH, CGRectGetHeight(self.view.frame));
            self.navView.frame = CGRectMake(0, 0, IPADLISTWIDTH, 64);
            self.roomList.frame = CGRectMake(0, 64, IPADLISTWIDTH,CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.navView.frame) -75);
            self.getRoomButton.frame = CGRectMake(15, CGRectGetMaxY(self.view.frame) - 60,IPADLISTWIDTH -30, 45);
            self.push.frame = self.view.bounds;
            [self.push updateLayout];
            UIImageView *bgImageView = [self.bgView viewWithTag:500];
            bgImageView.image = [UIImage imageNamed:@"homeBackGroundPortrait"];
        }else if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            if (initView) {
                initView.frame = [UIScreen mainScreen].bounds;
                UIImageView *bg = [initView viewWithTag:401];
                bg.image = [self getLaunchImage];
            }
            self.listBgView.frame = CGRectMake(0, 0, IPADLISTWIDTH, CGRectGetHeight(self.view.frame));
            self.navView.frame = CGRectMake(0, 0, IPADLISTWIDTH, 64);
            self.roomList.frame = CGRectMake(0, 64, IPADLISTWIDTH,CGRectGetHeight(self.view.frame)-CGRectGetMaxY(self.navView.frame) -75);
            self.getRoomButton.frame = CGRectMake(15, CGRectGetMaxY(self.view.frame) - 60,IPADLISTWIDTH -30, 45);
             self.push.frame = self.view.bounds;
            [self.push updateLayout];
            UIImageView *bgImageView = [self.bgView viewWithTag:500];
            bgImageView.image = [UIImage imageNamed:@"homeBackGroundLandscape"];
        }
    }
    
    self.oldInterface = self.interfaceOrientation;
    [self refreshImage];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    Class cellclass = NSClassFromString(@"UITableViewCellContentView");
    if([touch.view isKindOfClass:cellclass])
    {
        return NO;
    }else{
        return YES;
    }
}

// 滤镜效果
- (void)refreshImage
{
    UIImage *image = [self.bgView getImageWith:self.listBgView.frame];
    if (!image) {
        return;
    }
    UIColor *color = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
    UIImage * bgimage = [image applyBlurWithRadius:20 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
    [self.listBgView setImage:bgimage];
   // [self.listBgView setImageToBlur:image  blurRadius:20 completionBlock:^(){}];
}
- (void)shareMettingNotification:(NSNotification*)notification
{
    NSString *meetingID = [notification object];
    if (![[ServerVisit shead].authorization isEqualToString:@""]) {
        [self addItemAndEnterMettingWithID:meetingID];
    }else{
        [ToolUtils shead].meetingID = meetingID;
    }
}

- (void)notificationEnterNotification:(NSNotification*)notification
{
    NotificationObject *not = [notification object];
    if (![[ServerVisit shead].authorization isEqualToString:@""]) {
        [self.push close];
        if (self.videoViewController) {
            if ([self.videoViewController.roomItem.roomID isEqualToString:not.roomID]) {
                if (not.notificationType == NotificationMessageType) {
                    [self.videoViewController openOrCloseTalk:YES];
                }else{
                    [self.videoViewController openOrCloseTalk:NO];
                }
            }else{
                [self.videoViewController dismissMyself];
                [ASHUD showHUDWithStayLoadingStyleInView:self.view belowView:nil content:@""];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self gotoVideoWithNotification:not];
                });
               
            }
        }else{
            [self gotoVideoWithNotification:not];
           
        }
    }else{
        [ToolUtils shead].notificationObject = not;
    }
}

- (void)gotoVideoWithNotification:(NotificationObject*)obj
{
    RoomItem *item;
    NSInteger indx = 0;
    for (NSInteger i=0;i<self.dataArray.count;i++) {
        RoomItem *room = [self.dataArray objectAtIndex:i];
        if ([room.roomID isEqualToString:obj.roomID]) {
            item = room;
            indx = i;
            break;
        }
    }
    if (item) {
        __weak MainViewController *weakSelf = self;
        __block NSInteger index = indx;
        
        [ServerVisit getMeetingInfoWithId:item.roomID completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            if (!error) {
                NSDictionary *dict = (NSDictionary*)responseData;
                if ([[dict objectForKey:@"code"] integerValue] == 400) {
                    //该会议已经被持有人删除
                    [ASHUD hideHUD];
                    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该会议已经被持有人删除" icon:nil];
                    [weakSelf deleteRoomWithItem:item withIndex:index];
                }else if ([[dict objectForKey:@"code"] integerValue] == 200){
                    [weakSelf enterRoomTrue:item completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (obj.notificationType == NotificationMessageType) {
                                [weakSelf.videoViewController openOrCloseTalk:YES];
                            }
                        });
                    }];
                    [ToolUtils shead].notificationObject = nil;
                }
            }else{
                [ASHUD hideHUD];
            }
        }];
    }
}

#pragma mark -private methods
- (void)initUser
{
    UIView *initView = [[UIView alloc] initWithFrame:CGRectZero];
    initView.backgroundColor = [UIColor blackColor];
    initView.tag = 400;

    AppDelegate *apple = [RoomApp shead].appDelgate;
    [apple.window.rootViewController.view addSubview:initView];
    UIImageView *initViewBg = [UIImageView new];
    initViewBg.tag = 401;
    [initView addSubview:initViewBg];
    
    initViewBg.translatesAutoresizingMaskIntoConstraints = NO;
    initView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(initView,initViewBg);
    
    [apple.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[initView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [apple.window.rootViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[initView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    
    [initView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[initViewBg]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [initView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[initViewBg]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    
    initViewBg.image = [self getLaunchImage];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [initView addSubview:activityIndicatorView];
    
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* acViews = NSDictionaryOfVariableBindings(activityIndicatorView);

    [initView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[activityIndicatorView]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:acViews]];

    [initView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[activityIndicatorView]-380-|" options:NSLayoutFormatAlignAllTop metrics:nil views:acViews]];
    [activityIndicatorView startAnimating];
}

- (void)deviceInit
{
    __weak MainViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ServerVisit userInitWithUserid:[SvUDIDTools shead].UUID uactype:@"0" uregtype:@"3" ulogindev:@"3" upushtoken:[ServerVisit shead].deviceToken completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            if (!error) {
                NSDictionary *dict = (NSDictionary*)responseData;
                if ([[dict objectForKey:@"code"] integerValue] == 200) {
                    [ServerVisit shead].authorization = [dict objectForKey:@"authorization"];
                    [ServerVisit shead].nickName = [[dict objectForKey:@"information"] objectForKey:@"uname"];
                    [weakSelf getData];
                    [[TMMessageManage sharedManager] inintTMMessage];
                    
                }else{
                    
                }
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag = 901;
                [alertView show];
            }
        }];
    });
}

- (void)getData
{
    __weak MainViewController *weakSelf = self;
    [ServerVisit getRoomListWithSign:[ServerVisit shead].authorization withPageNum:1 withPageSize:20 completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] integerValue] == 200) {
                RoomVO *roomVO = [[RoomVO alloc] initWithParams:[dict objectForKey:@"meetingList"]];
                if (roomVO.deviceItemsList.count!=0) {
                    if (weakSelf.dataArray.count != 0) {
                        [weakSelf.dataArray removeAllObjects];
                    }
                    [weakSelf.dataArray addObjectsFromArray:roomVO.deviceItemsList];
                }
                [weakSelf.roomList reloadData];
                if (weakSelf.dataArray.count == 0) {
                    [EmptyViewFactory emptyMainView:weakSelf.roomList];
                }
                [[NtreatedDataManage sharedManager] dealwithDataWithTarget:self];
                if ([ToolUtils shead].meetingID != nil) {
                    [weakSelf addItemAndEnterMettingWithID:[ToolUtils shead].meetingID];
                }
                if ([ToolUtils shead].notificationObject != nil) {
                    [weakSelf gotoVideoWithNotification:[ToolUtils shead].notificationObject];
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    AppDelegate *apple = [RoomApp shead].appDelgate;
                    UIView *initView = [apple.window.rootViewController.view viewWithTag:400];
                    if (initView) {
                        [UIView animateWithDuration:0.3 animations:^{
                            initView.alpha = 0.0;
                        }completion:^(BOOL finished) {
                            [initView removeFromSuperview];
                        }];
                    }
                });
               // [initView removeFromSuperview];
                // judge is first start app
                if (![SvUDIDTools shead].notFirstStart) {
                    if (weakSelf.reNameAlertView) {
                        [weakSelf.reNameAlertView dismiss];
                        weakSelf.reNameAlertView = nil;
                    }
                    weakSelf.reNameAlertView = [[RoomAlertView alloc] initType:AlertViewModifyNameType withDelegate:self];
                    [weakSelf.reNameAlertView show];
                }
                
                // get not read message num
                [weakSelf getNotReadMessageNum];
            }
        }
    }];
}
- (UIImage*)getLaunchImage
{
    CGSize viewSize = self.view.bounds.size;
    
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    NSString *viewOrientation = @"Portrait";//横屏请设置成 @"Landscape"
    if (self.view.bounds.size.width>self.view.bounds.size.height) {
        viewOrientation = @"Landscape";
    }else{
        viewOrientation = @"Portrait";
    }
    for(NSDictionary* dict in imagesDict)
    {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            if (CGSizeEqualToSize(imageSize, viewSize)) {
                 launchImage = dict[@"UILaunchImageName"];
            }else{
                if (ISIPAD) {
                    launchImage = dict[@"UILaunchImageName"];
                }
            }
           
        }
        
    }
    return [UIImage imageNamed:launchImage];
}

- (void)getNotReadMessageNum
{
    @synchronized(dataArray) {
        if (dataArray.count != 0) {
            for (RoomItem *item in dataArray) {
                NSDictionary *dict = [[TMMessageManage sharedManager] getUnreadCountByRoomKeys:item.roomID,nil];

                NSArray *array = [dict objectForKey:item.roomID];
                if (array.count>1) {
                    item.messageNum = [[array objectAtIndex:0] integerValue];
                    item.lastMessagTime = [array objectAtIndex:1];
                }else{
                    item.messageNum = 0;
                }
            }
            [self.roomList reloadData];
        }
    }
}

- (void)setBackGroundImageView
{
    
    //todo  wyy
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView ];
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.tag = 500;
    [self.bgView addSubview:bgImageView];
    
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView,bgImageView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bgImageView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bgImageView]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    if (ISIPAD) {
        if (self.view.bounds.size.width>self.view.bounds.size.height) {
             bgImageView.image = [UIImage imageNamed:@"homeBackGroundLandscape"];
        }else{
            bgImageView.image = [UIImage imageNamed:@"homeBackGroundPortrait"];
        }
    }else{
         bgImageView.image = [UIImage imageNamed:@"homeBackGround"];
    }
}

-(void)displaySMSComposerSheet:(NSString*)roomID
{
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate =self;
    NSString *smsBody =[NSString stringWithFormat:@"让我们在会议中见!👉 %@#/%@",ShearUrl,roomID];
    
    picker.body=smsBody;
    
    [self presentViewController:picker animated:YES completion:^{
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)enterMeetingWithItem:(RoomItem*)item withIndex:(NSInteger)index
{
    if (item.mettingState == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该会议暂不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    __weak MainViewController *weakSelf = self;
    [ServerVisit getMeetingInfoWithId:item.roomID completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] integerValue] == 400) {
                [ASHUD hideHUD];
                //该会议已经被持有人删除
                [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该会议已经被持有人删除" icon:nil];
                [weakSelf deleteRoomWithItem:item withIndex:index];
                
            }else if ([[dict objectForKey:@"code"] integerValue] == 200){
                [weakSelf enterRoomTrue:item completion:^{
                    
                }];
            }
        }else{
            [ASHUD hideHUD];
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"进入会议出现异常" icon:nil];
        }
    }];
}
- (void)enterRoomTrue:(RoomItem*)item completion:(void (^ __nullable)(void))comp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.push) {
            [self.push close];
        }
        if (self.videoViewController) {
            self.videoViewController = nil;
        }
        self.videoViewController = [[VideoViewController alloc] init];
        self.videoViewController.roomItem = item;
        __weak MainViewController *weakSelf = self;
        [self.videoViewController setDismissVideoViewController:^{
            weakSelf.videoViewController = nil;
        }];
        UINavigationController *nai = [[UINavigationController alloc] initWithRootViewController:self.videoViewController];
        [self presentViewController:nai animated:YES completion:^{
            comp();
            [ServerVisit updateUserMeetingJointimeWithSign:[ServerVisit shead].authorization meetingID:item.roomID completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
                NSDictionary *dict = (NSDictionary*)responseData;
                item.jointime = [[dict objectForKey:@"jointime"] longValue];
                [weakSelf updataMeetingTime:item];
            }];
            if (tempRoomItem) {
                tempRoomItem = nil;
            }
        }];
    });
}

// 更新时间
- (void)updataMeetingTime:(RoomItem*)item
{
    @synchronized(dataArray) {
        for (RoomItem *roomItem in dataArray) {
            if ([roomItem.roomID isEqualToString:item.roomID]) {
                roomItem.jointime = item.jointime;

                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"jointime" ascending:NO];//jointime为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
                NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
                [dataArray sortUsingDescriptors:sortDescriptors];
                
                [self.roomList reloadData];
                break;
            }
        }
    }
}

- (void)updataDataWithServerResponse:(NSDictionary*)dict
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (dataArray.count==0) {
            return;
        }
        RoomItem *roomItem = [dataArray objectAtIndex:0];
        roomItem.roomID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"meetingid"]];
        roomItem.jointime = [[dict objectForKey:@"jointime"] longValue];
        roomItem.mettingType = [[dict objectForKey:@"meettype"] integerValue];
        roomItem.mettingState = [[dict objectForKey:@"meetenable"] integerValue];
        roomItem.anyRtcID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"anyrtcid"]];
        
        [dataArray replaceObjectAtIndex:0 withObject:roomItem];
        [self.roomList reloadData];
        [[SpotlightManager shead] addSearchableWithItem:roomItem];
    });
}
#pragma mark - button events
- (void)getRoomButtonEvent:(UIButton*)button
{
//    NSIndexPath *path = [[NSIndexPath alloc] initWithIndex:0];
//    [self.roomList scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.inputButton.hidden = YES;
    if (self.roomList.isEditing) {
        self.roomList.editing = NO;
    }
    [self.getRoomView showGetRoomView];
    
    RoomItem *roomItem = [[RoomItem alloc] init];
    roomItem.userID = [SvUDIDTools shead].UUID;
    [dataArray insertObject:roomItem atIndex:0];
    // 先把数据添加上，在搞下面的
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [indexPaths addObject: indexPath];
    
    [self.roomList beginUpdates];
    
    [self.roomList insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    [self.roomList endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.roomList reloadData];
    });
    
}

- (void)cancleButtonEvent:(UIButton*)button
{
    if (self.getRoomView) {
        [self.getRoomView dismissView];
    }
  
}
- (void)inputButtonEvent:(UIButton*)button
{
    EnterMeetingIDViewController *enterMeetingController = [EnterMeetingIDViewController new];
    enterMeetingController.mainViewController = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:enterMeetingController];
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark - publish server methods

// 添加
- (void)addRoomWithRoomName:(NSString*)roomName withPrivate:(BOOL)isPrivate
{
    @synchronized(dataArray) {
        RoomItem *roomItem = [dataArray objectAtIndex:0];
        roomItem.roomName = roomName;
        
        [dataArray replaceObjectAtIndex:0 withObject:roomItem];
        [self.roomList reloadData];
        
        self.cancleButton.hidden = YES;
        
        NtreatedData *data = [[NtreatedData alloc] init];
        data.actionType = CreateRoom;
        data.isPrivate = isPrivate;
        data.item = roomItem;
        [[NtreatedDataManage sharedManager] addData:data];
        
        __weak MainViewController *weakSelf = self;
        // 上传信息
        [ServerVisit applyRoomWithSign:[ServerVisit shead].authorization mettingId:roomItem.roomID mettingname:roomItem.roomName mettingCanPush:roomItem.canNotification  mettingtype:@"0" meetenable:isPrivate == YES ? @"2" : @"1" mettingdesc:@""  completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            NSLog(@"create room");
            NSDictionary *dict = (NSDictionary*)responseData;
            if (!error) {
                if ([[dict objectForKey:@"code"] intValue]== 200) {
                    [weakSelf updataDataWithServerResponse:[dict objectForKey:@"meetingInfo"]];
                    [[NtreatedDataManage sharedManager] removeData:data];
                    [weakSelf.push showWithType:PushViewTypeDefault withObject:roomItem withIndex:0];
                    if (weakSelf.dataArray.count>20) {
                        [weakSelf deleteRoomWithItem:[dataArray lastObject] withIndex:(dataArray.count -1)];
                    }
                }
            }
            
        }];
    }
}

// update room name
- (void)addTempDeleteData:(NSString*)roomName
{
    @synchronized(dataArray) {
        if (dataArray.count==0) {
            return;
        }
        // update object
        RoomItem *roomItem = [dataArray objectAtIndex:0];
        roomItem.roomName = roomName;
        [dataArray replaceObjectAtIndex:0 withObject:roomItem];
        
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = tempDataArray.count-1; i>-1; i--) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject: indexPath];
            RoomItem *item = [tempDataArray objectAtIndex:i];
            [dataArray insertObject:item atIndex:0];
        }
        
        
        [self.roomList beginUpdates];
        
        [self.roomList insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        
        [self.roomList endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.roomList reloadData];
        });
        
        NtreatedData *data = [[NtreatedData alloc] init];
        data.actionType = ModifyRoomName;
        data.item = roomItem;
        [[NtreatedDataManage sharedManager] addData:data];
        
        [ServerVisit updatateRoomNameWithSign:[ServerVisit shead].authorization mettingID:roomItem.roomID mettingName:roomName completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            NSLog(@"updata name");
            NSDictionary *dict = (NSDictionary*)responseData;
            if (!error) {
                if ([[dict objectForKey:@"code"] intValue]== 200) {
                    [[NtreatedDataManage sharedManager] removeData:data];
                    [[SpotlightManager shead] updateSearchableItem:roomItem];
                    
                }
            }
        }];
    }
}
// delete room
- (void)deleteRoomWithItem:(RoomItem*)item withIndex:(NSInteger)index
{
    @synchronized(dataArray) {
        if (index<0) {
            for (NSInteger i=0;i<dataArray.count;i++) {
                RoomItem *roomItem = [dataArray objectAtIndex:i];
                if ([roomItem.roomID isEqualToString:item.roomID]) {
                    index = i;
                    break;
                }
            }
        }
        
        [dataArray removeObject:item];
        
        if (dataArray.count == 0) {
            
            [EmptyViewFactory emptyMainView:self.roomList];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.roomList reloadData];
            });
        }else{
            [self.roomList beginUpdates];
            [self.roomList deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.roomList endUpdates];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.roomList reloadData];
            });
        }
        
        NtreatedData *data = [[NtreatedData alloc] init];
        data.actionType = ModifyRoomName;
        data.item = item;
        [[NtreatedDataManage sharedManager] addData:data];
        
        [ServerVisit deleteRoomWithSign:[ServerVisit shead].authorization meetingID:item.roomID completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            NSLog(@"delete room");
            NSDictionary *dict = (NSDictionary*)responseData;
            if (!error) {
                if ([[dict objectForKey:@"code"] intValue]== 200) {
                    [[NtreatedDataManage sharedManager] removeData:data];
                    [[SpotlightManager shead] deleteSearchableItem:item];
                    
                }
            }
        }];
    }
    
}
// update room can notification
- (void)updateNotification:(RoomItem*)item withClose:(BOOL)close withIndex:(NSInteger)index
{
    @synchronized(dataArray) {
        NtreatedData *data = [[NtreatedData alloc] init];
        data.actionType = SettingNotificationRoom;
        data.isNotification = close;
        data.item = item;
        [[NtreatedDataManage sharedManager] addData:data];
        
        [dataArray replaceObjectAtIndex:index withObject:item];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
        
        [indexPaths addObject: indexP];
        
        [self.roomList beginUpdates];
        
        [self.roomList reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        [self.roomList endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.roomList reloadData];
        });
        
        [ServerVisit updateRoomPushableWithSign:[ServerVisit shead].authorization meetingID:item.roomID pushable:[NSString stringWithFormat:@"%d",close] completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            NSLog(@"open or close push");
            NSDictionary *dict = (NSDictionary*)responseData;
            if (!error) {
                if ([[dict objectForKey:@"code"] intValue]== 200) {
                    [[NtreatedDataManage sharedManager] removeData:data];
                    
                }
            }
        }];
    }
    
}
// setting room is private
- (void)setPrivateMeeting:(RoomItem*)item withPrivate:(BOOL)private withIndex:(NSInteger)index
{
    @synchronized(dataArray) {
        NtreatedData *data = [[NtreatedData alloc] init];
        data.actionType = SettingPrivateRoom;
        data.isPrivate = private;
        data.item = item;
        [[NtreatedDataManage sharedManager] addData:data];
        
        [dataArray replaceObjectAtIndex:index withObject:item];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:index inSection:0];
        
        [indexPaths addObject: indexP];
        
        [self.roomList beginUpdates];
        
        [self.roomList reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        [self.roomList endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.roomList reloadData];
        });
        
        NSString *enable;
        if (private) {
            enable = @"2";
        }else{
            enable = @"1";
        }
        [ServerVisit updateRoomEnableWithSign:[ServerVisit shead].authorization meetingID:item.roomID enable:enable completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            NSLog(@"private meeting");
            NSDictionary *dict = (NSDictionary*)responseData;
            if (!error) {
                if ([[dict objectForKey:@"code"] intValue]== 200) {
                    [[NtreatedDataManage sharedManager] removeData:data];
                    
                }
            }
        }];
    }
    
}
// add others meeting in ours
- (void)insertUserMeetingRoomWithID:(RoomItem*)item
{
    @synchronized(dataArray) {
        BOOL find = NO;
        for (RoomItem *tempItem in dataArray) {
            if ([tempItem.roomID isEqualToString:item.roomID]) {
                find = YES;
                break;
            }
        }
        if (!find) {
            [ASHUD showHUDWithCompleteStyleInView:self.view content:nil icon:nil];
            __weak MainViewController *weakSelf = self;
            [ServerVisit insertUserMeetingRoomWithSign:[ServerVisit shead].authorization meetingID:item.roomID completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
                NSDictionary *dict = (NSDictionary*)responseData;
                [ASHUD hideHUD];
                if (!error) {
                    if ([[dict objectForKey:@"code"] integerValue] == 200) {
                        [weakSelf addItemAndEnterMetting:item];
                    }else{
                        
                    }
                }else{
                    
                }
            }];
        }else{
            // 先判断是否在会
            if (self.videoViewController && ![self.videoViewController.roomItem.roomID isEqualToString:item.roomID]) {
                [self.videoViewController dismissMyself];
                [ASHUD showHUDWithStayLoadingStyleInView:self.view belowView:nil content:@""];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self enterMeetingWithItem:item withIndex:-1];
                });
                
            }else if (self.videoViewController && [self.videoViewController.roomItem.roomID isEqualToString:item.roomID]){
               // 不做处理
            }else{
                // 直接进入会议
                [self enterMeetingWithItem:item withIndex:-1];
            }
        }

    }
}

- (void)addItemAndEnterMetting:(RoomItem*)item
{
    @synchronized(dataArray) {
        [dataArray insertObject:item atIndex:0];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [indexPaths addObject: indexPath];
        
        [self.roomList beginUpdates];
        
        [self.roomList insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        
        [self.roomList endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.roomList reloadData];
            [self enterRoomTrue:item completion:^{
                if (self.dataArray.count>20) {
                    [self deleteRoomWithItem:[dataArray lastObject] withIndex:(dataArray.count -1)];
                }
            }];
        });
    }
    
}

- (void)addItemAndEnterMettingWithID:(NSString*)meeting
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* number=@"^\\d{10}$";
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
        BOOL isTrue = [numberPre evaluateWithObject:meeting];
        if (isTrue) {
            __weak MainViewController *weakSelf = self;
            [ServerVisit  getMeetingInfoWithId:meeting completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
                if (!error) {
                    NSDictionary *dict = (NSDictionary*)responseData;
                    if ([[dict objectForKey:@"code"] integerValue] == 400) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"会议ID不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }else if ([[dict objectForKey:@"code"] integerValue] == 200){
                        NSDictionary *roomInfo = [dict objectForKey:@"meetingInfo"];
                        if ([[roomInfo objectForKey:@"meetenable"] integerValue]==2) {
                            // 私密会议不能添加和进入
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"私密会议不能添加，请联系其主人，让其关闭私密" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }else{
                            RoomItem *item = [[RoomItem alloc] init];
                            item.roomID = [roomInfo objectForKey:@"meetingid"];
                            item.roomName = [roomInfo objectForKey:@"meetname"];
                            item.createTime = [[roomInfo objectForKey:@"crttime"] longValue];
                            item.mettingDesc = [roomInfo objectForKey:@"meetdesc"];
                            item.mettingNum = [[roomInfo objectForKey:@"memnumber"] integerValue];
                            item.mettingType = [[roomInfo objectForKey:@"meettype1"] integerValue];
                            item.mettingState = [[roomInfo objectForKey:@"meetenable"] integerValue];
                            item.userID = [roomInfo objectForKey:@"userid"];
                            item.canNotification = [NSString stringWithFormat:@"%@",[roomInfo objectForKey:@"pushable"]];
                            item.anyRtcID = [NSString stringWithFormat:@"%@",[roomInfo objectForKey:@"anyrtcid"]];
                            [ToolUtils shead].meetingID = nil;
                            [weakSelf insertUserMeetingRoomWithID:item];
                        }
                    }
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"服务异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"会议ID不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    });
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.parIndexPath = indexPath;
    [cell setItem:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        RoomItem *item = [dataArray objectAtIndex:indexPath.row];
        [self enterMeetingWithItem:item withIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
  //当在Cell上滑动时会调用此函数
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return  UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomItem *deleteItem = [dataArray objectAtIndex:indexPath.row];
    [self deleteRoomWithItem:deleteItem withIndex:indexPath.row];
    
}
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath
{
    return @"删除";
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 901){
        if ([[ServerVisit shead].authorization isEqualToString:@""]) {
            [self deviceInit];
        }
    }else if (alertView.tag == 900){
        if (buttonIndex ==1) {
            // 先判断是否在会
            if (self.videoViewController && ![self.videoViewController.roomItem.roomID isEqualToString:tempRoomItem.roomID]) {
                [self.videoViewController dismissMyself];
                [ASHUD showHUDWithStayLoadingStyleInView:self.view belowView:nil content:@""];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self enterMeetingWithItem:tempRoomItem withIndex:-1];
                });
                
            }else if (self.videoViewController && [self.videoViewController.roomItem.roomID isEqualToString:tempRoomItem.roomID]){
                // 不做处理
            }else{
                // 直接进入会议
                [self enterMeetingWithItem:tempRoomItem withIndex:-1];
            }
        }
    }
}

#pragma mark - RoomViewCellDelegate
- (void)roomViewCellDlegateSettingEvent:(NSInteger)index
{
    if (self.roomList.isEditing) {
        return;
    }
    RoomItem *roomItem = [dataArray objectAtIndex:index];
    if ([roomItem.userID isEqualToString:[SvUDIDTools shead].UUID]) {
        [self.push showWithType:PushViewTypeSetting withObject:roomItem withIndex:index];
    }else{
        [self.push showWithType:PushViewTypeSettingConferee withObject:roomItem withIndex:index];
    }
   
}

#pragma mark - GetRoomViewDelegate

- (void)showCancleButton//show button
{
   self.cancleButton.hidden = NO;
}

- (void)getRoomWithRoomName:(NSString*)roomName withPrivateMetting:(BOOL)isPrivate
{
     self.inputButton.hidden = NO;
    [self addRoomWithRoomName:roomName withPrivate:isPrivate];
    
}
- (void)cancleGetRoom
{
    @synchronized(self.dataArray) {
        [dataArray removeObjectAtIndex:0];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [indexPaths addObject: indexPath];
        
        [self.roomList beginUpdates];
        
        [self.roomList deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.roomList endUpdates];
        
        self.cancleButton.hidden = YES;
        self.inputButton.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.roomList reloadData];
        });
    }
}

- (void)renameRoomNameScuess:(NSString*)roomName
{
    [self addTempDeleteData:roomName];
    self.cancleButton.hidden = YES;
    
}

// cancle update name
- (void)cancleRename:(NSString*)oldName
{
    [self addTempDeleteData:oldName];
     self.cancleButton.hidden = YES;
}

#pragma mark - RoomAlertViewDelegate

- (void)modifyNickName:(NSString *)nickName
{
    __weak MainViewController *weakSelf = self;
    if ([[ServerVisit shead].nickName isEqualToString:nickName]) {
        [SvUDIDTools shead].notFirstStart = YES;
        [self.reNameAlertView dismiss];
        self.reNameAlertView = nil;
        return;
    }
   
    
    [ServerVisit updataNickNameWithSign:[ServerVisit shead].authorization userID:nickName completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] integerValue]== 200) {
               [[TMMessageManage sharedManager] tmUpdateNickNameNname:nickName];
                [SvUDIDTools shead].notFirstStart = YES;
            }
        }
        [weakSelf.reNameAlertView dismiss];
        weakSelf.reNameAlertView = nil;
    }];
}

- (void)closeModifyNickName
{
    if (self.reNameAlertView) {
        [self.reNameAlertView dismiss];
        self.reNameAlertView = nil;
        [SvUDIDTools shead].notFirstStart = YES;
    }
}

#pragma mark - PushViewDelegate
- (void)pushViewInviteViaMessages:(RoomItem*)obj
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText]) {
            
            [self displaySMSComposerSheet:obj.roomID];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该设备不支持短信功能" icon:nil];
            });
        }
        
    }
}

- (void)pushViewInviteViaWeiXin:(RoomItem*)obj
{
    if ([WXApi isWXAppInstalled]) {
        NSLog(@"%@#/%@",ShearUrl,obj.roomID);
        [WXApiRequestHandler sendLinkURL:[NSString stringWithFormat:@"%@#/%@",ShearUrl,obj.roomID]
                                 TagName:nil
                                   Title:@"Teameeting"
                             Description:@"视频邀请"
                              ThumbImage:[UIImage imageNamed:@"Icon-1"]
                                 InScene:WXSceneSession];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"该设备没有安装微信" icon:nil];
        });
        
    }
    
}
- (void)pushViewInviteViaLink:(RoomItem*)obj
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@#/%@",ShearUrl,obj.roomID];
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"拷贝成功" icon:@"copy_scuess"];
}

- (void)pushViewJoinRoom:(RoomItem*)obj
{
    [ASHUD showHUDWithStayLoadingStyleInView:self.view belowView:nil content:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self enterMeetingWithItem:obj withIndex:-1];
    });
}
- (void)pushViewCloseOrOpenNotifications:(RoomItem *)obj withOpen:(BOOL)isOpen withIndex:(NSInteger)index
{
    [self updateNotification:obj withClose:isOpen withIndex:index];
}
- (void)pushViewPrivateMeeting:(RoomItem*)obj withPrivate:(BOOL)isPrivate withIndex:(NSInteger)index
{
    [self setPrivateMeeting:obj withPrivate:isPrivate withIndex:index];
}

- (void)pushViewRenameRoom:(RoomItem*)obj
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.roomList.isEditing) {
            self.roomList.editing = NO;
        }
        if (tempDataArray.count!=0) {
            [tempDataArray removeAllObjects];
        }
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i<dataArray.count; i++ ) {
            RoomItem *item = [dataArray objectAtIndex:i];
            if (item != obj) {
                [tempDataArray addObject:item];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }else{
                break;
            }
            
        }
        [dataArray removeObjectsInArray:tempDataArray];
        
        [self.roomList beginUpdates];
        
        [self.roomList deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        
        [self.roomList endUpdates];
        
        [self.getRoomView showWithRenameRoom:obj.roomName];
    });
    
    
}
- (void)pushViewDelegateRoom:(RoomItem*)obj withIndex:(NSInteger)index
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self deleteRoomWithItem:obj withIndex:index];
    });
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"短信发送成功" icon:nil];
    }else{
        [controller dismissViewControllerAnimated:YES completion:nil];
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"短信发送失败" icon:nil];
    }
    
}
#pragma mark -  tmMessageReceive
//state 1 in  2:leave
- (void)roomListMemberChangeWithRoomID:(NSString *)roomID changeState:(NSInteger)state
{
    @synchronized(dataArray) {
        for (RoomItem *item in dataArray) {
            if ([item.roomID isEqualToString:roomID]) {
                item.mettingNum = state;
                [self.roomList reloadData];
            }
        }
    }
}
// count: not read message num
- (void)roomListUnreadMessageChangeWithRoomID:(NSString *)roomID totalCount:(NSInteger)count lastMessageTime:(NSString *)time
{
    @synchronized(dataArray) {
        for (RoomItem *item in dataArray) {
            if ([item.roomID isEqualToString:roomID]) {
                item.messageNum = count;
                item.lastMessagTime = time;
                [self.roomList reloadData];
                break;
            }
        }
    }
}
- (BOOL)receiveMessageEnable
{
    return YES;
}
- (void)receiveCallShout:(NSDictionary*)responseDict
{
    NSLog(@"%@",[responseDict description]);
    
    for (RoomItem *roomItem in dataArray) {
        if ([roomItem.roomID isEqualToString:[responseDict objectForKey:@"room"]]) {
            tempRoomItem = roomItem;
            break;
        }
    }
    if (tempRoomItem) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@%@",[responseDict objectForKey:@"nname"],[responseDict objectForKey:@"cont"]] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"进会", nil];
        [alertView show];
        alertView.tag = 900;
    }
}
#pragma mark - monitor the network status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_netType"]){
        NSInteger type = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        NSLog(@"observeValueForKeyPath:%ld",(long)type);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type!=NoNet) {
                if ([[ServerVisit shead].authorization isEqualToString:@""]) {
                    [self deviceInit];
                }else{
                    AppDelegate *apple = [RoomApp shead].appDelgate;
                    UIView *initView = [apple.window.rootViewController.view viewWithTag:400];
                    if (initView) {
                        [self getData];
                    }else{
                        if (self.netAlertView) {
                            [self.netAlertView dismiss];
                            self.netAlertView = nil;
                        }
                    }
                [[NtreatedDataManage sharedManager] dealwithDataWithTarget:self];
                }
            }else{
                if (self.reNameAlertView) {
                    [self.reNameAlertView dismiss];
                    self.reNameAlertView = nil;
                }
                if (!self.netAlertView) {
                    self.netAlertView = [[RoomAlertView alloc] initType:AlertViewNotNetType withDelegate:self];
                    [self.netAlertView show];
                }
                
            }
        });
        
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (ISIPAD) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
}

- (BOOL)shouldAutorotate
{
    if (ISIPAD) {
        return YES;
    }else{
        return NO;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (ISIPAD) {
        return  UIInterfaceOrientationMaskAll;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
