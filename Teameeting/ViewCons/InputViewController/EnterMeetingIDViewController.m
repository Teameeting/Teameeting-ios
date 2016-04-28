//
//  EnterMeetingIDViewController.m
//  Room
//
//  Created by zjq on 16/1/7.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "EnterMeetingIDViewController.h"
#import "ServerVisit.h"
#import "UIImage+Category.h"

@interface EnterMeetingIDViewController ()<UITextFieldDelegate>
{
    UITextField *enterTextField;
    NSLayoutConstraint * constraint1;
    UIImageView *initViewBg;
}
@end

@implementation EnterMeetingIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"加入会议";
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 30, 30);
    [closeButton setImage:[UIImage imageNamed:@"close_enter"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *groupButton =[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = groupButton;
    
    
    initViewBg = [UIImageView new];
    [self.view addSubview:initViewBg];
    initViewBg.contentMode =  UIViewContentModeScaleAspectFill;
    initViewBg.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(initViewBg);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[initViewBg]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[initViewBg]-0-|" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    [self setBackGroundImage];
    
    enterTextField = [UITextField new];
    enterTextField.backgroundColor = [UIColor clearColor];
    enterTextField.textAlignment = NSTextAlignmentCenter;
    enterTextField.font = [UIFont boldSystemFontOfSize:18];
    enterTextField.textColor = [UIColor whiteColor];
    enterTextField.keyboardType = UIKeyboardTypeNumberPad;
    enterTextField.returnKeyType = UIReturnKeyDone;
    enterTextField.delegate = self;
    enterTextField.placeholder = @"会议ID";
    [self.view addSubview:enterTextField];
    [enterTextField becomeFirstResponder];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterButton setImage:[UIImage imageNamed:@"enter_go"] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterButton];
    
    UIImageView *lineImageView = [UIImageView new];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageView];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.textColor = [UIColor lightGrayColor];
    tishiLabel.font = [UIFont systemFontOfSize:14];
    tishiLabel.text = @"会议ID是一串十位的数字";
    [self.view addSubview:tishiLabel];
    
    
    enterTextField.translatesAutoresizingMaskIntoConstraints = NO;
    enterButton.translatesAutoresizingMaskIntoConstraints = NO;
    lineImageView.translatesAutoresizingMaskIntoConstraints = NO;
    tishiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (ISIPAD) {
        constraint1 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:CGRectGetHeight(self.view.frame)/3.5];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.6f constant:0.0f];
        
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45.f];
        
        [self.view addConstraint:constraint1];
        [self.view addConstraint:constraint2];
        [self.view addConstraint:constraint3];
        [self.view addConstraint:constraint4];
    }else{
        constraint1 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:CGRectGetHeight(self.view.frame)/4];
        
        NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:20.0f];
        
        NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
        
        NSLayoutConstraint * constraint4 = [NSLayoutConstraint constraintWithItem:enterTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:45.f];
        
        [self.view addConstraint:constraint1];
        [self.view addConstraint:constraint2];
        [self.view addConstraint:constraint3];
        [self.view addConstraint:constraint4];
   
    }
    NSLayoutConstraint * constraint5 = [NSLayoutConstraint constraintWithItem:enterButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint6 = [NSLayoutConstraint constraintWithItem:enterButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f];
    
    NSLayoutConstraint * constraint7 = [NSLayoutConstraint constraintWithItem:enterButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:35.0f];
    
    NSLayoutConstraint * constraint8 = [NSLayoutConstraint constraintWithItem:enterButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.f];
    
    NSLayoutConstraint * constraint9 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint10 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeBottom multiplier:1.0f constant:1.0f];
    
    NSLayoutConstraint * constraint11 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint12 = [NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:1.f];
    
    NSLayoutConstraint * constraint13 = [NSLayoutConstraint constraintWithItem:tishiLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint14 = [NSLayoutConstraint constraintWithItem:tishiLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lineImageView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:30.0f];
    
    NSLayoutConstraint * constraint15 = [NSLayoutConstraint constraintWithItem:tishiLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:enterTextField attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint * constraint16 = [NSLayoutConstraint constraintWithItem:tishiLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:25.f];
    
    [self.view addConstraint:constraint5];
    [self.view addConstraint:constraint6];
    [self.view addConstraint:constraint7];
    [self.view addConstraint:constraint8];
    [self.view addConstraint:constraint9];
    [self.view addConstraint:constraint10];
    [self.view addConstraint:constraint11];
    [self.view addConstraint:constraint12];
    [self.view addConstraint:constraint13];
    [self.view addConstraint:constraint14];
    [self.view addConstraint:constraint15];
    [self.view addConstraint:constraint16];
}

- (void)setBackGroundImage
{
    if (ISIPAD) {
        if (CGRectGetWidth(self.view.frame)>CGRectGetHeight(self.view.frame)) {
            UIColor *color = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
            initViewBg.image = [[UIImage imageNamed:@"homeBackGroundLandscape"] applyBlurWithRadius:20 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
        }else{
            UIColor *color = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
            initViewBg.image = [[UIImage imageNamed:@"homeBackGroundPortrait"] applyBlurWithRadius:20 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
        }
    }else{
        UIColor *color = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.8];
        initViewBg.image = [[UIImage imageNamed:@"homeBackGround"] applyBlurWithRadius:20 tintColor:color saturationDeltaFactor:1.8 maskImage:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (ISIPAD) {
        
        [self setBackGroundImage];
        [constraint1 setConstant:CGRectGetHeight(self.view.frame)/3.5];
        [self.view layoutIfNeeded];

    }
   
}
// enter meeting
- (void)enterButtonEvent:(UIButton*)button
{
    NSString* number=@"^\\d{10}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    BOOL isTrue = [numberPre evaluateWithObject:enterTextField.text];
    if (isTrue) {
        __weak EnterMeetingIDViewController *weakSelf = self;
        [ServerVisit  getMeetingInfoWithId:enterTextField.text completion:^(AFHTTPRequestOperation *operation, id responseData, NSError *error) {
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
                        item.createTime = [[roomInfo objectForKey:@"createtime"] longValue];
                        item.mettingDesc = [roomInfo objectForKey:@"meetdesc"];
                        item.mettingNum = [[roomInfo objectForKey:@"memnumber"] integerValue];
                        item.mettingType = [[roomInfo objectForKey:@"meettype"] integerValue];
                        item.mettingState = [[roomInfo objectForKey:@"meetenable"] integerValue];
                        item.userID = [roomInfo objectForKey:@"userid"];
                        item.canNotification = [NSString stringWithFormat:@"%@",[roomInfo objectForKey:@"pushable"]];
                        item.anyRtcID = [NSString stringWithFormat:@"%@",[roomInfo objectForKey:@"anyrtcid"]];
                        [weakSelf enterMeeting:item];
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
}
- (void)enterMeeting:(RoomItem*)item
{
    if (self.mainViewController) {
        [self.mainViewController insertUserMeetingRoomWithID:item];
    }
    [self closeButtonEvent:nil];
}
- (void)closeButtonEvent:(UIButton*)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self enterButtonEvent:nil];
    return YES;
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
