//
//  Message+CoreDataProperties.h
//  Room
//
//  Created by yangyang on 16/1/7.
//  Copyright © 2016年 zjq. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *belong;
@property (nullable, nonatomic, retain) NSString *time;
@end

NS_ASSUME_NONNULL_END
