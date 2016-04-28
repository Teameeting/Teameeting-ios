//
//  RootViewController.m
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "RootViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "ServerVisit.h"

@interface RootViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) int pageNum;
@property (strong, nonatomic) ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (assign,nonatomic) BOOL isViewLoad;
@property (assign,nonatomic) BOOL receiveEnable;
@end

@implementation RootViewController{
    UUInputFunctionView *IFView;
}

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.isViewLoad)
        return;
    self.isViewLoad = YES;
//    self.receiveEnable = NO;
    [self addRefreshViews];
    [self loadBaseViewsAndData];
    self.chatTableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    self.pageNum = 1;
    [[TMMessageManage sharedManager] registerMessageListener:self];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close_enter"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeChatView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    closeButton.frame = CGRectMake(0, 0, 28, 28);
    UIBarButtonItem *groupButton1 =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = groupButton1;
    if (ISIPAD) {
        [self.topConstraint setConstant:64];
    }
}

- (void)closeChatView
{
  
    if (self.closeRootViewBlock) {
        self.closeRootViewBlock();
    }
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!ISIPAD) {
        if (self.view.frame.size.width>self.view.frame.size.height) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }else{
             [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }
    if(IFView){
      [IFView layoutWithChange];
       [self.chatTableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[TMMessageManage sharedManager] removeMessageListener:self];
    [IFView removeFromSuperview];
    IFView = nil;
    if (self.chatTableView) {
        self.chatTableView = nil;
    }
}
- (void)initBar
{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@" private ",@" group "]];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}

- (void)setReceiveMessageEnable:(BOOL)enable {
    if (enable) {
        [[TMMessageManage sharedManager] clearUnreadCountByRoomKey:self.parentViewCon.roomItem.roomID];
        self.parentViewCon.badgeView.text = @"0";
    }
    self.receiveEnable = enable;
}

- (void)segmentChanged:(UISegmentedControl *)segment
{
    self.chatModel.isGroupChat = segment.selectedSegmentIndex;
    [self.chatModel.dataSource removeAllObjects];
    [self.chatModel populateRandomDataSource];
    [self.chatTableView reloadData];
}

- (void)addRefreshViews
{

    __weak typeof(self) weakSelf = self;
    self.chatTableView.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [ServerVisit getMeetingMsgListWithSign:[ServerVisit shead].authorization meetingID:weakSelf.parentViewCon.roomItem.roomID pageNum:[NSString stringWithFormat:@"%d",weakSelf.pageNum] pageSize:@"20" completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
            if (!error) {
                NSDictionary *dict = (NSDictionary*)responseData;
                if ([[dict objectForKey:@"code"] integerValue] ==200) {
                    
                    [weakSelf refreshDataFromNet:[dict objectForKey:@"messageList"] withFirst:NO];
                }
            }
            [weakSelf.chatTableView.header endRefreshing];
        }];
       
        
    }];
}
- (void)refreshDataFromNet:(NSArray*)array withFirst:(BOOL)isFirst
{
    if (array.count!=0) {
        self.pageNum++;
        [self.chatModel addNetDataItems:array];
        [self.chatTableView reloadData];
    }
    if (isFirst) {
         //[self performSelector:@selector(tableViewScrollToBottom) withObject:nil afterDelay:0.0];
//        [self tableViewScrollToBottom];
        if (self.chatModel.dataSource.count==0)
            return;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
   
}
- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    
    [ServerVisit getMeetingMsgListWithSign:[ServerVisit shead].authorization meetingID:self.parentViewCon.roomItem.roomID pageNum:[NSString stringWithFormat:@"%d",self.pageNum] pageSize:@"20" completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary*)responseData;
            if ([[dict objectForKey:@"code"] integerValue] ==200) {
                self.pageNum++;
                [self refreshDataFromNet:[dict objectForKey:@"messageList"]withFirst:YES];
            }
        }
    }];

    
}

- (void)resginKeyBord {
    
    [IFView.TextViewInput setText:@""];
    [IFView.TextViewInput resignFirstResponder];
    
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    UIViewController *parenetView = (UIViewController *)self.parentViewCon;
    BOOL isVertical = YES;
    NSUInteger width = parenetView.view.bounds.size.width;
    NSUInteger height = parenetView.view.bounds.size.height;
    isVertical = width > height ? NO : YES;
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        
        float keyBordHeight = keyboardEndFrame.size.width > keyboardEndFrame.size.height ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
        [IFView setFrame:CGRectMake(0, parenetView.view.bounds.size.height - keyBordHeight - 40, IFView.bounds.size.width, IFView.bounds.size.height)];
        [self.bottomConstraint setConstant:keyBordHeight + 40];
        [self.view layoutIfNeeded];
        
    } else if (notification.name == UIKeyboardWillHideNotification){
        
        [IFView setFrame:CGRectMake(0, parenetView.view.bounds.size.height - 40, IFView.bounds.size.width, IFView.bounds.size.height)];
        [self.view layoutIfNeeded];
        [self.bottomConstraint setConstant:40];
    }
    [UIView commitAnimations];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    
    if (self.chatModel.dataSource.count==0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - tmMessageReceive

- (void)messageDidReceiveWithContent:(NSString *)content messageTime:(NSString *)time withNickName:(NSString*)nickName withRoomId:(NSString *)roomID{
    
    if (![_parentViewCon.roomItem.roomID isEqualToString:roomID]) {
        return;
    }
    NSDictionary *dic = @{@"strContent": content,
                          @"strName":nickName,
                          @"type": @(UUMessageTypeText)};
    [self.chatModel addOtherItem:dic];
    [self.chatTableView reloadData];
    [self performSelector:@selector(tableViewScrollToBottom) withObject:nil afterDelay:0.3];
    if (!self.receiveEnable) {
        [[TMMessageManage sharedManager] insertMeeageDataWtihBelog:self.parentViewCon.roomItem.roomID content:content messageTime:time];
        self.parentViewCon.badgeView.text = [NSString stringWithFormat:@"%ld",([self.parentViewCon.badgeView.text integerValue]+1)];
    }
}

- (BOOL)receiveMessageEnable {
    
    return YES;
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    if (![[TMMessageManage sharedManager] connectEnable]) {
        return;
    }
    NSDictionary *dic = @{@"strContent": message,
                          @"strName":@"我",
                          @"type": @(UUMessageTypeText)};
    [funcView clearInputView];
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
    VideoViewController *videoCon = (VideoViewController *)self.parentViewCon;
    [[TMMessageManage sharedManager]sendMsgWithRoomid:videoCon.roomItem.roomID withRoomName:videoCon.roomItem.roomName msg:message];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addMySeleItem:dic];
    [self.chatTableView reloadData];
    [self performSelector:@selector(tableViewScrollToBottom) withObject:nil afterDelay:0.3];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row] isVertical:[self.parentViewCon isVertical]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

@end
