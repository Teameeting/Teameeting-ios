//
//  NetRequestUtils.m
//  VShow
//
//  Created by Zhang Jianqiang on 15/5/16.
//  Copyright (c) 2015年 EricTao. All rights reserved.
//

#import "NetRequestUtils.h"
#import "Base64Generater.h"
// 192.168.7.45
#define ASRequestInstance [NetRequestUtils sharedInstance]

#define REQUEST_TIME_OUT 30
#define REQUEST_SUCCESS 0

@interface NetRequestUtils()
{
    NSLock *_operationsDictLock;
}
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic, strong) NSMutableDictionary *operationsDict;
@end

@implementation NetRequestUtils
@synthesize operationManager;
- (id)init
{
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPRequestOperationManager manager];
        self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.operationManager.requestSerializer.timeoutInterval = REQUEST_TIME_OUT;
        //self.operationManager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
       // self.operationManager.responseSerializer.acceptableContentTypes = [self.operationManager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        self.operationsDict = [[NSMutableDictionary alloc]init];
        _operationsDictLock = [[NSLock alloc]init];
    }
    return self;
}
static NetRequestUtils *_requestUtils = nil;
+(NetRequestUtils*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestUtils = [[NetRequestUtils alloc] init];
    });
    return _requestUtils;
}
- (id)requestWithURL:(NSString *)url withType:(RequestType)type parameters:(NSDictionary *)params completion:(void (^)(AFHTTPRequestOperation *operation, id responseData, NSError *error))completion{
    AFHTTPRequestOperation *operation;
    if (operationManager) {
        [operationManager.requestSerializer clearAuthorizationHeader];
    }
    switch (type) {
        case 0:
        {
            operation = [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
        case 1:
        {
            operation = [operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
        case 2:
        {
            operation = [operationManager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
            
        default:
            break;
    }
    return operation;
}


- (id)requestWithURL:(NSString *)url withType:(RequestType)type parameters:(id)params withHead:(NSDictionary*)head completion:(void (^)(AFHTTPRequestOperation *operation, id responseData, NSError *error))completion{
    AFHTTPRequestOperation *operation;
    // 如果有头信息
    if (head) {
        for (NSString *key in head.allKeys) {
            [operationManager.requestSerializer setValue:[head objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    switch (type) {
        case 0:
        {
            operation = [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
        case 1:
        {
            operation = [operationManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
        case 2:
        {
            operation = [operationManager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObj){
                [ASRequestInstance check:responseObj operation:operation completion:completion];
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                if (completion) {
                    completion(operation,nil,error);
                }
                [self removeOperationWithUrl:[operation.request.URL absoluteString]];
            }];
            return operation;
        }
            break;
            
        default:
            break;
    }
    return operation;
}


- (id)requestWithURL:(NSString *)url  parameters:(id)params withHead:(NSDictionary*)head withData:(NSData*)data completion:(void (^)(AFHTTPRequestOperation *operation, id responseData, NSError *error))completion
{
    if (head) {
        
        for (NSString *key in head.allKeys) {
            
            [operationManager.requestSerializer setValue:[head objectForKey:key] forHTTPHeaderField:key];
            
        }
        
    }
    
    NSMutableURLRequest *request =
    
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    [request setHTTPBody:data];
    // 如果有头信息
    
    AFHTTPRequestOperation *operation = [operationManager HTTPRequestOperationWithRequest:request
                                         
                                                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                      
                                                                                      // 成功后的处理
                                                                                      
                                                                                      [ASRequestInstance check:responseObject operation:operation completion:completion];
                                                                                      
                                                                                      [self removeOperationWithUrl:[operation.request.URL absoluteString]];
                                                                                      
                                                                                  }
                                         
                                                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                      
                                                                                      // 失败后的处理
                                                                                      
                                                                                      if (completion) {
                                                                                          
                                                                                          completion(operation,nil,error);
                                                                                          
                                                                                      }
                                                                                      
                                                                                      [self removeOperationWithUrl:[operation.request.URL absoluteString]];
                                                                                      
                                                                                  }];
    
    [operationManager.operationQueue addOperation:operation];
    
    return operation;
    
}

- (void)check:(id)responseObj operation:(AFHTTPRequestOperation *)operation completion:(void(^)(AFHTTPRequestOperation *operation, id responseData, NSError *error))complemention{
    NSLog(@"checkurl:%@  \n  responseData:%@",operation.request.URL,responseObj);
    NSDictionary *responseDict = (NSDictionary *)responseObj;
    NSInteger code = (NSInteger)[responseDict valueForKey:@"errno"];
    if (code == REQUEST_SUCCESS || code == 10016) {
        if (complemention) {
            complemention(operation,responseObj,nil);
        }
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (code == 10006) {
                // 规定一个code来通知没有登录成功
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"kSessionInvalidNotification" object:nil];
            }
        });
        if (complemention) {
            complemention(operation,nil,[NSError errorWithDomain:nil code:code userInfo:@{NSLocalizedDescriptionKey : [responseDict valueForKey:@"errmsg"]}]);
        }
    }
}

- (void)addOperation:(AFHTTPRequestOperation *)operation url:(NSString *)url{
    [_operationsDictLock lock];
    [_operationsDict setObject:operation forKey:url];
    [_operationsDictLock unlock];
}

- (void)removeOperationWithUrl:(NSString *)url{
    [_operationsDictLock lock];
    [_operationsDict removeObjectForKey:url];
    [_operationsDictLock unlock];
}
- (AFHTTPRequestOperation *)operationForUrl:(NSString *)url{
    return [_operationsDict objectForKey:url];
}



+ (id)requestWithInterfaceStr:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",requesturlid,interfaceStr];
    return [ASRequestInstance requestWithURL:urlStr withType:type parameters:params completion:completion];
}

+ (id)requestWithInterfaceStrWithHeader:(NSString *)interfaceStr withRequestType:(RequestType)type parameters:(id)params completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",requesturlid,interfaceStr];
    
    //NSDictionary *headDict = [NSDictionary dictionaryWithObjectsAndKeys:[Base64Generater EncodedWithBase64:[NSString stringWithFormat:@"%@:%@",[[LoginUtil shead] userId],[LoginUtil lastAuthorization]]],@"Authorization", nil];
    NSDictionary *headDict = nil;
    
    return [ASRequestInstance requestWithURL:urlStr withType:type parameters:params withHead:headDict completion:completion];
}

+ (id)requestWithInterfaceStrWithBody:(NSString *)interfaceStr parameters:(id)params withHead:(NSDictionary*)head withBody:(NSData*)data completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",requesturlid,interfaceStr];
    
    return [ASRequestInstance requestWithURL:urlStr parameters:params withHead:head withData:data completion:completion];
}

@end



