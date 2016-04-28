//
//  UIDevice+Category.m
//  Dropeva
//
//  Created by zjq on 15/10/14.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "UIDevice+Category.h"

@implementation UIDevice (Category)
+ (iPhoneModel)iPhonesModel {
    //bounds method gets the points not the pixels!!!
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    //get current interface Orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //unknown
    if (UIInterfaceOrientationUnknown == orientation) {
        return UnKnown;
    }
    
    //    portrait   width * height
    //    iPhone4:320*480
    //    iPhone5:320*568
    //    iPhone6:375*667
    //    iPhone6Plus:414*736
    
    //portrait
    if (UIInterfaceOrientationPortrait == orientation) {
        if (width ==  320.0f) {
            if (height == 480.0f) {
                return iPhone5Below;
            } else {
                return iPhone5Below;
            }
        } else if (width == 375.0f) {
            return iPhone6;
        } else if (width == 414.0f) {
            return iPhone6Plus;
        }
    } else if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation) {//landscape
        if (height == 320.0) {
            if (width == 480.0f) {
                return iPhone5Below;
            } else {
                return iPhone5Below;
            }
        } else if (height == 375.0f) {
            return iPhone6;
        } else if (height == 414.0f) {
            return iPhone6Plus;
        }
    }
    
    return UnKnown;
}

+ (BOOL)isSystemVersioniOS8
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        return YES;
    }else{
        return NO;
    }
}

@end
