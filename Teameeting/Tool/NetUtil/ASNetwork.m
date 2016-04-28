//
//  ASNetwork.m
//  ASASShopping
//
//  Created by work on 14/12/29.
//  Copyright (c) 2014年 work. All rights reserved.
//

#import "ASNetwork.h"
#import "AFNetworkReachabilityManager.h"

@interface ASNetwork()
{
}
@end

@implementation ASNetwork
@synthesize _netType;

static ASNetwork *_network = NULL;

- (id)init
{
    self = [super init];
    if (self) {
        [self isNetWorkReachable];
    }
    return self;
}

+ (ASNetwork*)sharedNetwork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _network = [[ASNetwork alloc]init];
    });
    return _network;
}

- (void)isNetWorkReachable{
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                if (self._netType == NoNet) {
                    break;
                }
                self._netType = NoNet;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                if (self._netType == WIFINet) {
                    break;
                }
                self._netType = WIFINet;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                if (self._netType == ViaWWANNet) {
                    break;
                }
                self._netType = ViaWWANNet;
                break;
            }
            default:
                break;
        }
    }];
}

@end
