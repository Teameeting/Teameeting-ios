//
//  FackNavView.m
//  Room
//
//  Created by zjq on 15/12/9.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "FackNavView.h"

@implementation FackNavView

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //1.context
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //2.set strokecolor
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 133.0/255.0, 138.0/255.0, 141.0/255.0, 1);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1);  //line width
    //setting start point
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    //setting end point
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    //rendering
    CGContextStrokePath(ctx);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
