//
//  SvUDIDTools.h
//  SvUDID
//
//  Created by  maple on 8/18/13.
//  Copyright (c) 2013 maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SvUDIDTools : NSObject

+ (SvUDIDTools*)shead;

@property (nonatomic, strong)NSString *UUID;

@property (nonatomic, assign) BOOL notFirstStart;



@end
