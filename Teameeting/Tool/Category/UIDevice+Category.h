//
//  UIDevice+Category.h
//  Dropeva
//
//  Created by zjq on 15/10/14.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(char, iPhoneModel){
         iPhone5Below,//320*568
         iPhone6,//375*667
         iPhone6Plus,//414*736
         UnKnown
};

@interface UIDevice (Category)

+ (iPhoneModel)iPhonesModel;
+ (BOOL)isSystemVersioniOS8;

@end
