//
//  AppDelegate.h
//  Teameeting
//
//  Created by zjq on 16/1/11.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *appKey = @"28dbfe51120dc34905044161";
static NSString *channel = @"App Store";
#ifdef DEBUG
static BOOL isProduction = FALSE;
#else
static BOOL isProduction = TRUE;
#endif


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

