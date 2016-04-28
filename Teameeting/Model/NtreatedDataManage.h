//
//  NtreatedDataManage.h
//  Room
//
//  Created by yangyang on 15/12/18.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NtreatedData.h"
#import "MainViewController.h"

@interface NtreatedDataManage : NSObject



+ (NtreatedDataManage *)sharedManager;
- (void)dealwithDataWithTarget:(MainViewController*)target;
- (BOOL)addData:(NtreatedData *)data;
- (BOOL)removeData:(NtreatedData *)data;
- (NSMutableArray *)getData;

@end
