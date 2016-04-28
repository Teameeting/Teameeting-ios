//
//  TMMessageManage.m
//  Room
//
//  Created by yangyang on 16/1/5.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import "TMMessageManage.h"
#import "Message.h"
#import "Rooms.h"
#import "SvUDIDTools.h"
#import "ServerVisit.h"
#import "ToolUtils.h"
#import "JPUSHService.h"
#import "RoomApp.h"

@interface TMMessageManage() <MsgClientProtocol>


@property(nonatomic,strong)TMMsgSender *msg;
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong)NSMutableArray *messageListeners;
- (void)saveCoreData;
- (NSURL *)applicationDocumentsDirectory;
- (void)deleteDataFromMessageTableWithKey:(NSString *)key;
@end

@implementation TMMessageManage

+ (TMMessageManage *)sharedManager
{
    static TMMessageManage *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    
    if (self = [super init]) {
        
        _msg = [[TMMsgSender alloc] init];
        _messageListeners = [NSMutableArray array];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    return self;
}

- (void)dealloc {
    
    [_msg tMUint];
}

- (void)inintTMMessage {
    //192.168.7.39 :6630      180.150.179.128  :6630
    [_msg tMInitMsgProtocol:self uid:[SvUDIDTools shead].UUID token:[ServerVisit shead].authorization nname:[ServerVisit shead].nickName server:TMMessageUrl port:6630];
}

- (void)registerMessageListener:(id<tmMessageReceive>)listener {
    
    if (![self.messageListeners containsObject:listener]) {
        
        [self.messageListeners addObject:listener];
    }
}

- (void)removeMessageListener:(id<tmMessageReceive>)listener {
    
    if ([self.messageListeners containsObject:listener]) {
        
        [self.messageListeners removeObject:listener];
    }
}

#pragma CoreDataAction

- (void)saveCoreData {
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {

        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TMessage" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TMessage.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
      
    }
    return _persistentStoreCoordinator;
}

- (void)insertMeeageDataWtihBelog:(NSString *)belong content:(NSString *)content messageTime:(NSString *)time
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    message.belong = belong;
    message.content = content;
    message.time = [NSString stringWithFormat:@"%@",time];
    NSError *error;
    if(![context save:&error])
    {
       NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void)insertRoomDataWithKey:(NSString *)key {

    NSManagedObjectContext *context = [self managedObjectContext];
    Rooms *room = [NSEntityDescription insertNewObjectForEntityForName:@"Rooms" inManagedObjectContext:context];
    room.name = key;
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    
}

- (NSUInteger)getUnreadCountByRoomKey:(NSString *)key lasetTime:(NSString **)time{
    
    NSMutableArray *messages = [NSMutableArray array];
    NSArray *searchResult = [self selectDataFromMessageTableWithKey:key pageSize:20 currentPage:0];
    [messages addObjectsFromArray:searchResult];
    int index = 0;
    while ([searchResult count] != 0) {
        
        index ++;
        searchResult = [self selectDataFromMessageTableWithKey:key pageSize:20 currentPage:[searchResult count]];
        [messages addObjectsFromArray:searchResult];
    }
    Message *lastMessage = [messages lastObject];
    *time = lastMessage.time;
    return [messages count];
}

- (NSDictionary *)getUnreadCountByRoomKeys:(NSString *)key, ... {
    
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
    va_list args;
    va_start(args, key);
    NSString *lastTime = nil;
    NSUInteger count = [self getUnreadCountByRoomKey:key lasetTime:&lastTime];

    [messageDic setObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:count], lastTime,nil] forKey:key];
    
    if (key)
    {
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *)))
        {
            NSUInteger count = [self getUnreadCountByRoomKey:otherString lasetTime:&lastTime];
            [messageDic setObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:count], lastTime,nil] forKey:otherString];
        }
    }
    va_end(args);
    return messageDic;
}

- (void)clearUnreadCountByRoomKey:(NSString*)key
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    
    NSString *searchSql = [NSString stringWithFormat:@"belong BEGINSWITH[cd]  '%@'",key];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:searchSql];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    [request setPredicate:qcondition];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }

}

- (NSMutableArray*)selectDataFromMessageTableWithKey:(NSString *)key pageSize:(NSUInteger)size currentPage:(NSInteger)page
{

    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *searchSql = [NSString stringWithFormat:@"belong BEGINSWITH[cd]  '%@'",key];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:searchSql];
    [fetchRequest setPredicate:qcondition];
    [fetchRequest setFetchLimit:size];
    [fetchRequest setFetchOffset:page];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (Message *item in fetchedObjects) {
        
        [resultArray addObject:item];
    }
    return resultArray;
}

- (NSMutableArray *)selectDataFromRoomTableWithKey:(NSString *)key pageSize:(NSUInteger)size currentPage:(NSInteger)page {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *searchSql = [NSString stringWithFormat:@"name BEGINSWITH[cd]  '%@'",key];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:searchSql];
    [fetchRequest setPredicate:qcondition];
    [fetchRequest setFetchLimit:size];
    [fetchRequest setFetchOffset:page];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Rooms" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (Rooms *item in fetchedObjects) {
        
        [resultArray addObject:item];
    }
    return resultArray;
}


-(void)deleteDataFromRoomTableWithKey:(NSString *)key
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Rooms" inManagedObjectContext:context];
    
    NSString *searchSql = [NSString stringWithFormat:@"name BEGINSWITH[cd]  '%@'",key];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:searchSql];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    [request setPredicate:qcondition];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (Rooms *obj in datas)
        {
            [self deleteDataFromMessageTableWithKey:obj.name];
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

- (void)deleteDataFromMessageTableWithKey:(NSString *)key {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:context];
    
    NSString *searchSql = [NSString stringWithFormat:@"belong BEGINSWITH[cd]  '%@'",key];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:searchSql];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    [request setPredicate:qcondition];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

- (void)updateMessageTableDataWithKey:(NSString *)key data:(NSString *)data
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",key];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Message" inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    Message *item = [result firstObject];
    if ([context save:&error]) {
        
        NSLog(@"%@",item.description);
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark TMessage Action


- (int)sendMsgWithRoomid:(NSString *)roomid withRoomName:(NSString*)roomName msg:(NSString *)msg {
    
   return [self.msg tMSndMsgRoomid:roomid rname:roomName msg:msg];
}

- (int)tmRoomCmd:(MCMeetCmd)cmd roomid:(NSString *)roomid withRoomName:(NSString*)roomName remain:(NSString *)remain {

    return [self.msg tMOptRoomCmd:cmd roomid:roomid rname:roomName remain:remain];
}

- (int)tMNotifyMsgRoomid:(NSString*)roomid withRoomName:(NSString*)roomName withTags:(MCSendTags)tags withMessage:(NSString*)meg
{
    int tag = [self.msg tMNotifyMsgRoomid:roomid rname:roomName tags:tags msg:meg];
    return tag;
}

- (void) tmUpdateNickNameNname:(NSString*)nickName
{
    [self.msg tMSetNickNameNname:nickName];
}
//接收消息
- (void) OnSndMsgMsg:(NSString *) msg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if ([[messageDic objectForKey:@"tags"] intValue] == MCSendTagsTALK) {
            
            if (![[messageDic objectForKey:@"room"] isEqualToString:[ToolUtils shead].roomID]) {
                
                [[TMMessageManage sharedManager] insertMeeageDataWtihBelog:[messageDic objectForKey:@"room"] content:[messageDic objectForKey:@"cont"] messageTime:[messageDic objectForKey:@"ntime"]];
                for ( id<tmMessageReceive> object in self.messageListeners) {
                    
                    if ([object respondsToSelector:@selector(roomListUnreadMessageChangeWithRoomID:totalCount:lastMessageTime:)] && [object receiveMessageEnable]) {
                        
                        NSString *lastMessageTime = nil;
                        NSInteger messageCount = [[TMMessageManage sharedManager] getUnreadCountByRoomKey:[messageDic objectForKey:@"room"] lasetTime:&lastMessageTime];
                        [object roomListUnreadMessageChangeWithRoomID:[messageDic objectForKey:@"room"] totalCount:messageCount lastMessageTime:lastMessageTime];
                        
                    }
                }
                
            }else{
                for (id<tmMessageReceive> object in self.messageListeners) {
                    
                    if ([object respondsToSelector:@selector(messageDidReceiveWithContent:messageTime:withNickName:withRoomId:)] && [object receiveMessageEnable]) {
                        
                        if (![[messageDic objectForKey:@"from"] isEqualToString:[SvUDIDTools shead].UUID]) {
                            
                            [object messageDidReceiveWithContent:[messageDic objectForKey:@"cont"] messageTime:[messageDic objectForKey:@"ntime"] withNickName:[messageDic objectForKey:@"nname"] withRoomId:[messageDic objectForKey:@"room"]];
                        }
                        break;
                    }
                    
                }
                
            }
            if ([ToolUtils shead].isBack) {
                if (![[RoomApp shead] canSendLocalNotificationWithRoomID:[messageDic objectForKey:@"room"]]) {
                    return;
                }
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
                if (notification != nil) {
                    // 设置推送时间（5秒后）
                    notification.fireDate = pushDate;
                    // 设置时区（此为默认时区）
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    // 设置重复间隔（默认0，不重复推送）
                    notification.repeatInterval = 0;
                    // 推送声音（系统默认）
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    // 推送内容
                    notification.alertBody = [NSString stringWithFormat:@"%@ - %@:%@",[messageDic objectForKey:@"rname"],[messageDic objectForKey:@"nname"],[messageDic objectForKey:@"cont"]];
                    //设置userinfo 方便在之后需要撤销的时候使用
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"tags",[messageDic objectForKey:@"room"],@"roomid", nil];
                    notification.userInfo = info;
                    //添加推送到UIApplication
                    UIApplication *app = [UIApplication sharedApplication];
                    [app scheduleLocalNotification:notification];
                }
                
            }
            
        } else if ([[messageDic objectForKey:@"tags"] intValue] == MCSendTagsENTER || [[messageDic objectForKey:@"tags"] intValue] == MCSendTagsLEAVE) {
        
            for (id<tmMessageReceive> object in self.messageListeners) {
                
                if ([object respondsToSelector:@selector(roomListMemberChangeWithRoomID:changeState:)] && [object receiveMessageEnable]) {
                        [object roomListMemberChangeWithRoomID:[messageDic objectForKey:@"room"] changeState:[[messageDic objectForKey:@"nmem"] intValue]];
                }
            }
            
        }else if ([[messageDic objectForKey:@"tags"] intValue] == MCSendTagsCALL){
            NSLog(@"喊人啦");
            if (![[RoomApp shead] canRemindWithLocalNotificationWithRoomID:[messageDic objectForKey:@"room"]]) {
                return;
            }
            
            if ([ToolUtils shead].isBack) {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
                if (notification != nil) {
                    // 设置推送时间（5秒后）
                    notification.fireDate = pushDate;
                    // 设置时区（此为默认时区）
                    notification.timeZone = [NSTimeZone defaultTimeZone];
                    // 设置重复间隔（默认0，不重复推送）
                    notification.repeatInterval = 0;
                    // 推送声音（系统默认）
                    notification.soundName = @"ring.caf";
                    // 推送内容
                    notification.alertBody = [NSString stringWithFormat:@"%@%@",[messageDic objectForKey:@"nname"],[messageDic objectForKey:@"cont"]];
                    //设置userinfo 方便在之后需要撤销的时候使用
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4],@"tags",[messageDic objectForKey:@"room"],@"roomid", nil];
                    notification.userInfo = info;
                    //添加推送到UIApplication
                    UIApplication *app = [UIApplication sharedApplication];
                    [app scheduleLocalNotification:notification];
                }
                
            }else{
                for (id<tmMessageReceive> object in self.messageListeners) {
                    
                    if ([object respondsToSelector:@selector(receiveCallShout:)] && [object receiveMessageEnable]) {
                        [object receiveCallShout:messageDic];
                        break;
                    }
                }
            }
        }
        
    });
}

- (BOOL)connectEnable {
    
    return [self.msg tMConnStatus] == MCConnStateCONNECTED ? YES : NO;
}

- (void) OnGetMsgMsg:(NSString*) msg {
    
    
}


- (void) OnMsgServerConnected {
    
    
}

- (void) OnMsgServerDisconnect {
    
    
}

- (void) OnMsgServerConnectionFailure {
    
    
}

- (void) OnMsgServerStateConnState:(MCConnState) state {
    //the connection state between client and server
    //when the state has changed, this callback will be invoked
   // NSLog(@"OnMsgServerStateConnState state:%ld", state);
}

@end
