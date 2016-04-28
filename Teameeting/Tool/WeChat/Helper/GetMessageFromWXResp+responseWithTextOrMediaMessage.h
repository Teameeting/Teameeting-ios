//
//  GetMessageFromWXResp+responseWithTextOrMediaMessage.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApiObject.h"
#import <UIKit/UIKit.h>
@interface GetMessageFromWXResp (responseWithTextOrMediaMessage)

+ (GetMessageFromWXResp *)responseWithText:(NSString *)text
                            OrMediaMessage:(WXMediaMessage *)message
                                     bText:(BOOL)bText;
@end
