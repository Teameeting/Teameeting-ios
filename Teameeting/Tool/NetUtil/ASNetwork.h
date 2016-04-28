//
//  ASNetwork.h
//  ASASShopping
//
//  Created by work on 14/12/29.
//  Copyright (c) 2014年 work. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetType){
    NoNet = 0,
    WIFINet = 1,
    ViaWWANNet = 2,
};

@interface ASNetwork : NSObject

+ (ASNetwork*)sharedNetwork;

@property (nonatomic) NetType _netType;

@end
