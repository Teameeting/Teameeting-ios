//
//  LockerView.h
//  DemoAnnitation
//
//  Created by yangyang on 15/11/5.
//  Copyright © 2015年 yangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define OPENVIDEO @"OPENVIDEO"

@protocol LockerDelegate <NSObject>

- (void)menuClick:(UIButton *)item;

@end

@interface LockerButton : UIButton


@property(nonatomic,assign)BOOL isSelect;
@end


@interface LockerView : UIView


@property(nonatomic,assign)id<LockerDelegate> delegate;
@property(nonatomic,assign)BOOL isHiden;
- (void)showEnable:(BOOL)enable;
@end
