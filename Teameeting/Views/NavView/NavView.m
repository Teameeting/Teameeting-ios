//
//  NavView.m
//  LotusSutraHD
//
//  Created by zjq on 15/12/16.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "NavView.h"

@interface NavView()
{
    BackBlock block;
}
@property (nonatomic, strong) UILabel *titleLabe;
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation NavView

@synthesize titleLabe;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/4, 20, frame.size.width/2, 44)];
        self.titleLabe.textAlignment = NSTextAlignmentCenter;
        self.titleLabe.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabe.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabe];
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 63.5, frame.size.width, 0.5)];
        self.lineImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineImageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    if (self.titleLabe) {
        self.titleLabe.frame = CGRectMake(frame.size.width/4, 20, frame.size.width/2, 44);
    }
    if (self.lineImageView) {
        self.lineImageView.frame = CGRectMake(0, frame.size.height-.5, frame.size.width, .5);
    }
    
}

- (void)setTitle:(NSString *)title
{
    self.titleLabe.text = title;
}
- (void)createNavBack:(BackBlock)bck
{
    if (block) {
        block = nil;
    }
    block = bck;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, 28, 28, 28);
//    [leftButton setImage:[UIImage imageNamed:@"kr-video-player-back_nor"] forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(backEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
}
- (void)backEvent:(UIButton*)button
{
    if (block) {
        block();
    }
}


@end
