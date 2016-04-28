//
//  UIImage+Category.h
//  CoreDataDemo
//
//  Created by zjq on 16/1/11.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;
@end
