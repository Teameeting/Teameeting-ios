//
//  NSString+Category.m
//  Teameeting
//
//  Created by zjq on 16/1/12.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
