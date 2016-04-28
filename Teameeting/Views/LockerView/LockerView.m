//
//  LockerView.m
//  DemoAnnitation
//
//  Created by yangyang on 15/11/5.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import "LockerView.h"

@implementation LockerButton




@end


@interface LockerView ()


@property(nonatomic,strong)LockerButton *originButton;
@property(nonatomic,strong)LockerButton *exchangeButton;
@property(nonatomic,strong)LockerButton *closeVideoButton;

@property(nonatomic,strong)LockerButton *leaveButton;
@property(nonatomic,strong)LockerButton *micButton;

@property(nonatomic,strong)LockerButton *selectButton;
@end

@implementation LockerView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];
        self.originButton = [LockerButton buttonWithType:UIButtonTypeCustom];
        self.originButton.tag = 0;
        [self.originButton setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
        self.originButton.frame = CGRectMake(0, 0, 67, 67);
        [self.originButton setBackgroundColor:[UIColor clearColor]];
        self.originButton.center = CGPointMake(self.originButton.center.x, frame.size.height/2);
        [self.originButton addTarget:self action:@selector(showSubViews:) forControlEvents:UIControlEventTouchUpInside];
        
        self.exchangeButton = [LockerButton buttonWithType:UIButtonTypeCustom];
        [self.exchangeButton setBackgroundImage:[UIImage imageNamed:@"changeVideo"] forState:UIControlStateNormal];
        self.exchangeButton.hidden = YES;
        self.exchangeButton.tag = 30;
        [self.exchangeButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.exchangeButton setBackgroundColor:[UIColor clearColor]];
        self.exchangeButton.frame = CGRectMake(0, 0, 67, 67);
        self.exchangeButton.center = self.originButton.center;
        
        self.closeVideoButton = [LockerButton buttonWithType:UIButtonTypeCustom];
        [self.closeVideoButton setBackgroundImage:[UIImage imageNamed:@"closeVideo"] forState:UIControlStateNormal];
        self.closeVideoButton.hidden = YES;
        self.closeVideoButton.tag = 40;
        [self.closeVideoButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeVideoButton setBackgroundColor:[UIColor clearColor]];
        self.closeVideoButton.frame = CGRectMake(0, 0, 67, 67);
        self.closeVideoButton.center = self.originButton.center;
        [self addSubview:self.closeVideoButton];
        [self addSubview:self.exchangeButton];
        [self addSubview:self.originButton];
        
        self.leaveButton = [LockerButton buttonWithType:UIButtonTypeCustom];
        self.leaveButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.leaveButton.tag = 10;
        [self.leaveButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.leaveButton setBackgroundColor:[UIColor clearColor]];
        self.leaveButton.frame = CGRectMake(0, 0, 67, 67);
        [self.leaveButton setBackgroundImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
        [self.leaveButton setBackgroundImage:[UIImage imageNamed:@"hangupselect"] forState:UIControlStateHighlighted];
        self.leaveButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        self.micButton = [LockerButton buttonWithType:UIButtonTypeCustom];
        self.micButton.tag = 20;
        self.micButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.micButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.micButton setBackgroundImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        [self.micButton setBackgroundImage:[UIImage imageNamed:@"micselect"] forState:UIControlStateHighlighted];
        
        [self.micButton setBackgroundColor:[UIColor clearColor]];
        self.micButton.frame = CGRectMake(0, 0, 67, 67);
        self.micButton.center = CGPointMake(self.bounds.size.width - 35, self.bounds.size.height/2);
        
        [self addSubview:self.leaveButton];
        [self addSubview:self.micButton];
    }
    return self;
}

- (void)itemClick:(LockerButton *)item {
    
    if ([self.delegate respondsToSelector:@selector(menuClick:)]) {
        
        self.selectButton = item;
        [self.delegate menuClick:item];
    }
}

- (void)showSubViews:(LockerButton *)button {
   
    
    if (self.originButton.selected) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:OPENVIDEO object:nil];
        self.originButton.selected = NO;
        self.closeVideoButton.isSelect = NO;
        return;
        
    }
    if (!button.isSelect) {
        
        self.exchangeButton.hidden = NO;
        self.closeVideoButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.exchangeButton.center = CGPointMake(self.bounds.size.width/2, self.exchangeButton.center.y);
            self.closeVideoButton.center = CGPointMake(self.bounds.size.width - 35, self.closeVideoButton.center.y);
            self.leaveButton.alpha = 0;
            self.micButton.alpha = 0;
            
        }];
        
        [UIView animateWithDuration:0.15 animations:^{
            
            button.transform = CGAffineTransformMakeRotation(359 *M_PI_2 /180);
            CGAffineTransform transform = button.transform;
            button.transform = CGAffineTransformScale(transform, 1,1);
            //button.layer.transform = CATransform3DMakeRotation((0*180)/180,0,0,1);
        }];
        
        [button setBackgroundImage:[UIImage imageNamed:@"menucancel"] forState:UIControlStateNormal];
        button.isSelect = YES;
        
        
    } else {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            //button.layer.transform = CATransform3DMakeRotation((M_PI*180)/180,0,0,1);
            button.transform = CGAffineTransformMakeRotation(0 *M_PI_2 / 180.0);
            CGAffineTransform transform = button.transform;
            button.transform = CGAffineTransformScale(transform, 1,1);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                self.exchangeButton.center = CGPointMake(35, self.exchangeButton.center.y);
                self.closeVideoButton.center = CGPointMake(35, self.closeVideoButton.center.y);
                
            } completion:^(BOOL finished) {
                
                self.exchangeButton.hidden = YES;
                self.closeVideoButton.hidden = YES;
            }];
            [UIView animateWithDuration:0.2 animations:^{
                
                self.leaveButton.alpha = 1;
                self.micButton.alpha = 1;
            }];
            
        }];
        if (self.selectButton && self.selectButton.isSelect && self.selectButton.tag == 40) {
            
            [self.originButton setBackgroundImage:[UIImage imageNamed:@"changeSelectVideo"] forState:UIControlStateNormal];
            self.originButton.selected = YES;
            
        } else {
            
            [button setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
        }
        button.isSelect = NO;
    }
}

- (void)showEnable:(BOOL)enable {
    
    self.originButton.isSelect = enable;
    [self showSubViews:self.originButton];
}


@end
