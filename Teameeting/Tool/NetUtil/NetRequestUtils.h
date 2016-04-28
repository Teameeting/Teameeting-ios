//
//  NetRequestUtils.h
//  VShow
//
//  Created by Zhang Jianqiang on 15/5/16.
//  Copyright (c) 2015年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestType)
{
    PostType,
    GetType,
    PutTypt
};

@interface NetRequestUtils : NSObject
/*!
 POST请求
 @param 
      interfaceStr 方法
 @param 
      type 网络请求方法
 @param 
      params 参数
 @result
 operation:AFHTTPRequestOperation.
 responseData:api返回的json数据
 @return AFHTTPRequestOperation 的实例.
 */

+ (id)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params  completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

/*!
 POST请求
 @param
 interfaceStr 方法
 @param
 type 网络请求方法
 @param
 params 参数
 @param
 head 头信息
 @result
 operation:AFHTTPRequestOperation.
 responseData:api返回的json数据
 @return AFHTTPRequestOperation 的实例.
 */

+ (id)requestWithInterfaceStrWithHeader:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;


/*!
 POST请求
 @param
 interfaceStr 方法
 @param
 type 网络请求方法
 @param
 params 参数
 @param
 head 头信息
 @result
 operation:AFHTTPRequestOperation.
 responseData:api返回的json数据
 @return AFHTTPRequestOperation 的实例.
 */

+ (id)requestWithInterfaceStrWithBody:(NSString *)interfaceStr parameters:(id)params withHead:(NSDictionary*)head withBody:(NSData*)data completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;




@end
