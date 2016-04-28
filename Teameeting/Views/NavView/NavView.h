//
//  NavView.h
//  LotusSutraHD
//
//  Created by zjq on 15/12/16.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView
@property (nonatomic, strong) NSString *title;
typedef void(^BackBlock)(void);

- (void)createNavBack:(BackBlock)block;

@end
