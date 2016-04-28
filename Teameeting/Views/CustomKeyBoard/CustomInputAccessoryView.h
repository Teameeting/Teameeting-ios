//
//  CustomInputAccessoryView.h
//  Room
//
//  Created by zjq on 15/12/29.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomInputAccessoryViewDelegate <NSObject>
- (void) customInputAccessoryViewDelegateOpenPrivate:(BOOL)isOpen; // 是否打开私密
@end

@interface CustomInputAccessoryView : UIView

- (id)initWithTextField:(UITextField *)textField;

@property (nonatomic, weak)id<CustomInputAccessoryViewDelegate>delegate;

@end
