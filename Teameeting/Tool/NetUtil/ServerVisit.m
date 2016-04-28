//
//  ServerVisit.m
//  Room
//
//  Created by yangyang on 15/12/4.
//  Copyright © 2015年 zjq. All rights reserved.
//

#import "ServerVisit.h"
#import "NetRequestUtils.h"
@implementation ServerVisit
- (id)init
{
    self = [super init];
    if (self) {
        self.deviceToken = @"";
        self.authorization = @"";
        self.nickName = @"";
    }
    return self;
}
static ServerVisit *_server = nil;
+ (ServerVisit*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _server = [[ServerVisit alloc] init];
    });
    return _server;
}


+ (void)userInitWithUserid:(NSString *)uid uactype:(NSString *)utype uregtype:(NSString *)gtype ulogindev:(NSString *)ltype upushtoken:(NSString *)token completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"userid",utype,@"uactype",gtype,@"uregtype",ltype,@"ulogindev",token,@"upushtoken", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"users/init" withRequestType:PostType parameters:parameters completion:completion];
}
+ (void)applyRoomWithSign:(NSString *)gn mettingId:(NSString *)mid mettingname:(NSString *)mname mettingCanPush:(NSString *)pushNum mettingtype:(NSString *)mtype meetenable:(NSString *)metable mettingdesc:(NSString *)mdesc completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mname,@"meetingname",mtype,@"meetingtype",mdesc,@"meetdesc",mid,@"meetingid",pushNum,@"pushable",metable,@"meetenable", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/applyRoom" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updatateRoomNameWithSign:(NSString*)gn mettingID:(NSString*)mid mettingName:(NSString*)mname completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mname,@"meetingname",mid,@"meetingid", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateMeetRoomName" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updateDeviceTokenWithSign:(NSString*)gn withToken:(NSString*)token completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",token,@"upushtoken",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"users/updatePushtoken" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)deleteRoomWithSign:(NSString *)gn meetingID:(NSString *)mid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/deleteRoom" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)addMemRoomWithSign:(NSString *)gn meetingID:(NSString *)mid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateRoomAddMemNumber" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)reduceMemRoomWithSign:(NSString *)gn meetingID:(NSString *)mid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateRoomMinuxMemNumber" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updateRoomPushableWithSign:(NSString *)gn meetingID:(NSString *)mid pushable:(NSString *)able completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",able,@"pushable",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateRoomPushable" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)updateRoomEnableWithSign:(NSString *)gn meetingID:(NSString *)mid enable:(NSString *)able completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",able,@"enable",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateRoomEnable" withRequestType:PostType parameters:parameters completion:completion];
    
}
+ (void)getRoomListWithSign:(NSString *)gn
                withPageNum:(int)pageNum
               withPageSize:(int)pageSize
                 completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",[NSString stringWithFormat:@"%d",pageNum],@"pageNum",[NSString stringWithFormat:@"%d",pageSize],@"pageSize",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/getRoomList" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updateRoomMemNumberWithSign:(NSString *)gn meetingID:(NSString *)mid meetingMemNumber:(NSString *)meetNumer completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",meetNumer,@"meetingMemNumber",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateRoomMemNumber" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)getMeetingMsgListWithSign:(NSString *)gn meetingID:(NSString *)mid pageNum:(NSString *)page pageSize:(NSString *)size completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",page,@"pageNum",size,@"pageSize", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/getMeetingMsgList" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)insertMeetingMsgWithSign:(NSString *)gn meetingID:(NSString *)mid messageid:(NSString *)mesgId messageType:(NSString *)mesgType sessionID:(NSString *)sessid strMsag:(NSString *)msg userId:(NSString *)userid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",mesgId,@"messageid", mesgType,@"messagetype",sessid,@"sessionid",msg,@"strMsg",userid,@"userid",  nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/insertMeetingMsg" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)insertSessionMeetingInfoWithSign:(NSString *)gn meetingID:(NSString *)mid sessionID:(NSString *)sessid sessionStatus:(NSString *)status sessionType:(NSString *)type sessionNumber:(NSString *)sNumber completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",sessid,@"sessionid", status,@"sessionstatus",type,@"sessiontype",sNumber,@"*sessionnumber", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/insertSessionMeetingInfo" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)updateSessionMeetingStatusWithSign:(NSString *)gn sessionID:(NSString *)sessid sessionStatus:(NSString *)status completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",sessid,@"sessionid",status,@"sessionstatus", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateSessionMeetingStatus" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updateSessionMeetingEndtimeWithSign:(NSString *)gn sessionid:(NSString *)sessid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",sessid,@"sessionid", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateSessionMeetingEndtime" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)updateSessionMeetingNumberWithSign:(NSString *)gn sessionID:(NSString *)sessid sessionNumber:(NSString *)sNumber completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",sessid,@"sessionid",sNumber,@"sessionnumber", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateSessionMeetingNumber" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)updateUserMeetingJointimeWithSign:(NSString *)gn meetingID:(NSString *)mid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/updateUserMeetingJointime" withRequestType:PostType parameters:parameters completion:completion];
    
}

+ (void)insertUserMeetingRoomWithSign:(NSString *)gn meetingID:(NSString *)mid completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/insertUserMeetingRoom" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)pushMeetingMsgWithSign:(NSString *)gn meetingID:(NSString *)mid pushMsg:(NSString *)msg notification:(NSString *)noti completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",mid,@"meetingid",msg,@"pushMsg",noti,@"notification", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/pushMeetingMsg" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)pushCommonMsgWithSign:(NSString *)gn targetID:(NSString *)target pushMsg:(NSString *)msg notification:(NSString *)noti completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",target,@"targetid",msg,@"pushMsg",noti,@"notification", nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"meeting/pushCommonMsg" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)signoutRoomWithSign:(NSString *)gn completion:(void (^)(AFHTTPRequestOperation *, id, NSError *))completion {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"users/signout" withRequestType:PostType parameters:parameters completion:completion];
}

+ (void)getMeetingInfoWithId:(NSString*)meetingID
                  completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSString *meeting = [NSString stringWithFormat:@"meeting/getMeetingInfo/%@",meetingID];
    [NetRequestUtils requestWithInterfaceStr:meeting withRequestType:GetType parameters:nil completion:completion];
}

+ (void)updataNickNameWithSign:(NSString*)gn
                        userID:(NSString*)userID
                    completion:(void (^)(AFHTTPRequestOperation *operation ,id responseData,NSError *error))completion
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:gn,@"sign",userID,@"nickname",nil];
    [NetRequestUtils requestWithInterfaceStrWithHeader:@"users/updateNickname" withRequestType:PostType parameters:parameters completion:completion];
}
@end
