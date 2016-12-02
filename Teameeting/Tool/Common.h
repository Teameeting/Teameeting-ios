//
//  Common.h
//  DropevaSDK
//
//  Created by yangyang on 15/11/6.
//  Copyright © 2015年 yangyangwang. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // 判断设备是不是iPad
#define ISIPADMainList 320   // 列表的宽度
#define VideoParViewHeight 260
#define TalkPannelWidth 340
#define ShearUrl @"https://www.teameeting.cn/share_meetingRoom/"
#define ShareMettingNotification @"ShareMettingNotification"
#define NotificationEntNotification @"NotificationEntNotification"

#if 1
#define requesturlid  @"http://restful.teameeting.cn:8055"
#define TMMessageUrl @"message.anyrtc.io"
#else
#define requesturlid  @"http://192.168.7.218:8055"
#define TMMessageUrl @"192.168.7.207"
#endif

//#define TMMessageUrl @"message.anyrtc.io"
#endif /* Common_h */
