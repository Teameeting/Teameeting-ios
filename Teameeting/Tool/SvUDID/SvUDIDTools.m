//
//  SvUDIDTools.m
//  SvUDID
//
//  Created by  maple on 8/18/13.
//  Copyright (c) 2013 maple. All rights reserved.
//

#import "SvUDIDTools.h"
#import <Security/Security.h>
#import "A0SimpleKeychain.h"


static NSString *const kSSKeychainServiceName = @"TeameetingService";
static NSString *const kSSKeychainAccountName = @"TeameetingAccount";

@implementation SvUDIDTools

static SvUDIDTools *uuidTool = nil;

+ (SvUDIDTools*)shead
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         uuidTool = [[SvUDIDTools alloc] init];
    });
    return uuidTool;
}

- (id)init
{
    self = [super init];
    if (self) {
         NSError *error;
         //_UUID = [SSKeychain passwordForService:kSSKeychainServiceName account:kSSKeychainAccountName error:&error];
        _UUID = [[A0SimpleKeychain keychain] stringForKey:kSSKeychainServiceName];
        if (!_UUID) {
//             _UUID = [A0SimpleKeychain passwordForService:kSSKeychainServiceName account:kSSKeychainAccountName error:&error];
             _UUID = [[A0SimpleKeychain keychain] stringForKey:kSSKeychainServiceName];
        }
       self.notFirstStart = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isUpateNickName"] boolValue];
        if (!_UUID) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            assert(uuid != NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            _UUID = [[NSString stringWithFormat:@"%@",uuidStr] lowercaseString];
            _UUID = [_UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //[SSKeychain setPassword: _UUID forService:kSSKeychainServiceName account:kSSKeychainAccountName error:&error];
            [[A0SimpleKeychain keychain] setString:_UUID forKey:kSSKeychainServiceName];
            CFRelease(uuid);
            CFRelease(uuidStr);
           
            if (error) {
                NSLog(@"SSKeychain Faile");
            }
        }
        NSLog(@"UUID：%@",_UUID);
    }
    return self;
}
- (void)setNotFirstStart:(BOOL)notFirstStart
{
    
    _notFirstStart = notFirstStart;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:notFirstStart] forKey:@"isUpateNickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
