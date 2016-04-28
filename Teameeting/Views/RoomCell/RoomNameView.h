//
//  RoomNameView.h
//  Teameeting
//
//  Created by zjq on 16/1/12.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomVO.h"

@interface RoomNameView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
- (void)setItem:(RoomItem*)item;
@end
