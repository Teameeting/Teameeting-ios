//
//  AudioManager.h
//  Teameeting
//
//  Created by jianqiangzhang on 16/2/29.
//  Copyright © 2016年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

- (void)closeProximityMonitorEnable;
// 打开扬声器
- (void)setSpeakerOn;

@end
