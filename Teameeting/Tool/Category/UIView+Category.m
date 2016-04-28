//
//  UIImageView+Category.m
//  GPUImageDemo
//
//  Created by zjq on 15/12/30.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (UIImage*)getImageWith:(CGRect)rect
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height );
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self.layer renderInContext:context];
    UIImage * theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], rect);
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

@end
