//
//  UILabel+Category.m
//  Room
//
//  Created by yangyang on 15/11/24.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel(StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end
