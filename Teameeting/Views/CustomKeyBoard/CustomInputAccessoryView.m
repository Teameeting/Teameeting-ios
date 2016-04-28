//
//  CustomInputAccessoryView.m
//  Room
//
//  Created by zjq on 15/12/29.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "CustomInputAccessoryView.h"

@interface CustomInputAccessoryView()
{
    
}
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CustomInputAccessoryView

- (id)initWithTextField:(UITextField *)textField
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    if (self) {
        textField.inputAccessoryView = self;
        
        self.backgroundColor = [UIColor whiteColor];
        self.switchView = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 44, 44)];
        [self.switchView addTarget:self action:@selector(switchViewEvent:) forControlEvents:UIControlEventValueChanged];
        self.switchView.on = NO;
        self.switchView.center = CGPointMake(CGRectGetWidth(self.frame)-44, self.center.y);
        [self addSubview:self.switchView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(self.switchView.frame)-20, 44)];
        self.titleLabel.text = @"私密会议:";
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.titleLabel];
    
        
    }
    return self;
}
- (void)switchViewEvent:(UISwitch*)swif
{
    if (_delegate && [_delegate respondsToSelector:@selector(customInputAccessoryViewDelegateOpenPrivate:)]) {
        [_delegate customInputAccessoryViewDelegateOpenPrivate:swif.isOn];
    }
}
- (void)layoutSubviews
{
    if (self.switchView) {
        self.switchView.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 44, 44);
        self.switchView.center = CGPointMake(CGRectGetWidth(self.frame)-44, self.center.y);
    }
    if (self.titleLabel) {
        self.titleLabel.frame = CGRectMake(0, 0, CGRectGetMinX(self.switchView.frame)-20, 44);
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 51/255., 51/255., 51/255., 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}


@end
