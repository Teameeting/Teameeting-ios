//
//  ServerVisit.h
//  Room
//
//  Created by yangyang on 15/12/4.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ServerVisit : NSObject

+ (ServerVisit*)shead;

@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong) NSString *authorization;  // 验证头信息
@property (nonatomic, strong) NSString *nickName;       // 昵称

+ (void)userInitWithUserid:(NSString *)uid
                   uactype:(NSString *)utype
                  uregtype:(NSString *)gtype
                 ulogindev:(NSString *)ltype
                upushtoken:(NSString *)token
                completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)applyRoomWithSign:(NSString *)gn
                mettingId:(NSString*)mid
              mettingname:(NSString *)mname
           mettingCanPush:(NSString*)pushNum
              mettingtype:(NSString *)mtype
               meetenable:(NSString *)metable
              mettingdesc:(NSString *)mdesc
               completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updatateRoomNameWithSign:(NSString*)gn
                       mettingID:(NSString*)mid
                     mettingName:(NSString*)mname
                      completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateDeviceTokenWithSign:(NSString*)gn
                        withToken:(NSString*)token
                       completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)deleteRoomWithSign:(NSString *)gn
                 meetingID:(NSString *)mid
                completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)addMemRoomWithSign:(NSString *)gn
                 meetingID:(NSString *)mid
                completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)reduceMemRoomWithSign:(NSString *)gn
                    meetingID:(NSString *)mid
                   completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateRoomPushableWithSign:(NSString *)gn
                         meetingID:(NSString *)mid
                          pushable:(NSString *)able
                        completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateRoomEnableWithSign:(NSString *)gn
                         meetingID:(NSString *)mid
                          enable:(NSString *)able
                      completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)getRoomListWithSign:(NSString *)gn
                withPageNum:(int)pageNum
               withPageSize:(int)pageSize
                 completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateRoomMemNumberWithSign:(NSString *)gn
                          meetingID:(NSString *)mid
                   meetingMemNumber:(NSString *)meetNumer
                         completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)getMeetingMsgListWithSign:(NSString *)gn
                        meetingID:(NSString *)mid
                          pageNum:(NSString *)page
                         pageSize:(NSString *)size
                       completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)insertMeetingMsgWithSign:(NSString *)gn
                       meetingID:(NSString *)mid
                       messageid:(NSString *)mesgId
                     messageType:(NSString *)mesgType
                       sessionID:(NSString *)sessid
                         strMsag:(NSString *)msg
                          userId:(NSString *)userid
                      completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)insertSessionMeetingInfoWithSign:(NSString *)gn
                               meetingID:(NSString *)mid
                               sessionID:(NSString *)sessid
                           sessionStatus:(NSString *)status
                             sessionType:(NSString *)type
                           sessionNumber:(NSString *)sNumber
                              completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateSessionMeetingStatusWithSign:(NSString *)gn
                                 sessionID:(NSString *)sessid
                             sessionStatus:(NSString *)status
                                completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateSessionMeetingEndtimeWithSign:(NSString *)gn
                                  sessionid:(NSString *)sessid
                                 completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateSessionMeetingNumberWithSign:(NSString *)gn
                                 sessionID:(NSString *)sessid
                             sessionNumber:(NSString *)sNumber
                                completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updateUserMeetingJointimeWithSign:(NSString *)gn
                                meetingID:(NSString *)mid
                               completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)insertUserMeetingRoomWithSign:(NSString *)gn
                            meetingID:(NSString *)mid
                           completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)pushMeetingMsgWithSign:(NSString *)gn
                     meetingID:(NSString *)mid
                       pushMsg:(NSString *)msg
                  notification:(NSString *)noti
                    completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)pushCommonMsgWithSign:(NSString *)gn
                     targetID:(NSString *)target
                      pushMsg:(NSString *)msg
                 notification:(NSString *)noti
                   completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)signoutRoomWithSign:(NSString *)gn
                 completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)getMeetingInfoWithId:(NSString*)meetingID
                  completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;

+ (void)updataNickNameWithSign:(NSString*)gn
                        userID:(NSString*)userID
                    completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion;
@end
