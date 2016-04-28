//
//  Rooms+CoreDataProperties.h
//  Room
//
//  Created by yangyang on 16/1/7.
//  Copyright © 2016年 zjq. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rooms.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rooms (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
