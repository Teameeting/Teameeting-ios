//
//  RoomAlertView.m
//  Room
//
//  Created by zjq on 15/12/8.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "RoomAlertView.h"
#import "ServerVisit.h"

@interface RoomAlertView()
{
    UIActivityIndicatorView *activityIndicatorView;
    UITextField *inputTextField;
    
}
@property (nonatomic,weak)id<RoomAlertViewDelegate>delegate;
@property (nonatomic, strong) UIView *alertView;
@end

@implementation RoomAlertView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initType:(AlertViewType)type withDelegate:(id<RoomAlertViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
        if (type == AlertViewNotNetType) {
            if (ISIPAD) {
                self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
            }else{
                  self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 80, CGRectGetHeight([UIScreen mainScreen].bounds)/2)];
            }
          
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
            iconImageView.center = CGPointMake(self.alertView.center.x, CGRectGetHeight(iconImageView.frame));
            iconImageView.image = [UIImage imageNamed:@"no_net_alert"];
            [self.alertView addSubview:iconImageView];
            
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame), 20)];
            orderLabel.textAlignment = NSTextAlignmentCenter;
            orderLabel.font = [UIFont boldSystemFontOfSize:20];
            orderLabel.text = @"网络连接出错";
            NSLog(@"%f %f",(self.alertView.center.y -30),CGRectGetMaxY(iconImageView.frame) );
            if (self.alertView.center.y - 30 < CGRectGetMaxY(iconImageView.frame)) {
                 orderLabel.center = CGPointMake(self.alertView.center.x, CGRectGetMaxY(iconImageView.frame)+20);
                
            }else{
                orderLabel.center = CGPointMake(self.alertView.center.x, self.alertView.center.y-20);
            }
            [self.alertView addSubview:orderLabel];
            
            
            UILabel *nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(orderLabel.frame), CGRectGetWidth(self.alertView.frame) - 80, 80)];
            
            nextLabel.textAlignment = NSTextAlignmentCenter;
            nextLabel.numberOfLines = 0;
            nextLabel.font = [UIFont systemFontOfSize:16];
            nextLabel.text = @"世界上最遥远得距离就是没网。请检查设置";
            [self.alertView addSubview:nextLabel];
            
            
            UIButton *tryButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tryButton.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame)- CGRectGetHeight(self.alertView.frame)/6 ,CGRectGetWidth(self.alertView.frame), CGRectGetHeight(self.alertView.frame)/6);
            [tryButton setTitle:@"试一下" forState:UIControlStateNormal];
            [tryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tryButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
            tryButton.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
            [tryButton addTarget:self action:@selector(tryButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:tryButton];
    
            
            activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityIndicatorView.center = CGPointMake(tryButton.center.x + tryButton.center.x/2, tryButton.center.y);
            [self.alertView addSubview:activityIndicatorView];
            
        }else if(type == AlertViewModifyNameType){
            if (ISIPAD) {
                self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            }else{
                self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 80, 200)];
            }
            
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(10, 10, 30, 30);
            [closeButton addTarget:self action:@selector(closeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setImage:[UIImage imageNamed:@"nick_close"] forState:UIControlStateNormal];
            [self.alertView addSubview:closeButton];
            
            UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.alertView.frame), 25)];
            orderLabel.textAlignment = NSTextAlignmentCenter;
            orderLabel.font = [UIFont boldSystemFontOfSize:20];
            orderLabel.text = @"修改昵称";
            orderLabel.center = CGPointMake(self.alertView.center.x, 50);
            [self.alertView addSubview:orderLabel];
            
            inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(orderLabel.frame)+25, CGRectGetWidth(self.alertView.frame)-40, 45)];
            inputTextField.textAlignment = NSTextAlignmentCenter;
            inputTextField.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:241.0/255.0 blue:239.0/255.0 alpha:1.0];
            inputTextField.text = [ServerVisit shead].nickName;
            [self.alertView addSubview:inputTextField];
            [inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            doneButton.frame = CGRectMake(0, CGRectGetHeight(self.alertView.frame)-45, CGRectGetWidth(self.alertView.frame), 45);
            [doneButton setTitle:@"确定" forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
            doneButton.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:139.0/255.0 blue:75.0/255.0 alpha:1.0];
            
            [doneButton addTarget:self action:@selector(doneButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:doneButton];
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
            
        }
        
        self.alertView.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1.0];
        
        self.alertView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:self.alertView];
        
        self.alpha = 0.0;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
    }
    return self;
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
    
  
    BOOL isVertical = YES;
    NSUInteger width = [UIScreen mainScreen].bounds.size.width;
    NSUInteger height = [UIScreen mainScreen].bounds.size.height;
    isVertical = width > height ? NO : YES;
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        
        float keyBordHeight = keyboardEndFrame.size.width > keyboardEndFrame.size.height ? keyboardEndFrame.size.height : keyboardEndFrame.size.width;
        self.alertView.frame = CGRectMake(self.alertView.frame.origin.x, [UIScreen mainScreen].bounds.size.height-keyBordHeight-CGRectGetHeight(self.alertView.frame), CGRectGetWidth(self.alertView.frame), CGRectGetHeight(self.alertView.frame));


        
    } else if (notification.name == UIKeyboardWillHideNotification){
        
        self.alertView.center = CGPointMake(self.center.x, self.center.y);
    }
    [UIView commitAnimations];
}

- (void)textFieldDidChange:(UITextField*)textField
{
    if (textField == inputTextField) {
        NSLog(@"%lu",textField.text.length);
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
}


- (void)tryButtonEvent:(UIButton*)tryButton
{
    if (activityIndicatorView) {
        [activityIndicatorView startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [activityIndicatorView stopAnimating];
        });
    }
}

- (void)doneButtonEvent:(UIButton*)doneButton
{
    if (inputTextField.text.length==0) {
        CGPoint point  = inputTextField.layer.position;
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
        shake.duration = 0.1;
        shake.autoreverses = YES;
        shake.repeatCount = 4;
        shake.fromValue = [NSValue valueWithCGPoint:point];
        shake.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x+10, point.y)];
        [inputTextField.layer addAnimation:shake forKey:@"move-layer"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(modifyNickName:)]) {
        [self.delegate modifyNickName:inputTextField.text];
    }
}

- (void)closeButtonEvent:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(closeModifyNickName)]) {
        [self.delegate closeModifyNickName];
    }
}

- (void)updateFrame
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.alertView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
}

- (void)show
{
    self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.alertView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.15 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.alertView removeFromSuperview];
            [self removeFromSuperview];
        }];
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
