//
//  TimeTrackerDatabaseCoreData.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTDatabase.h"
#import <sqlite3.h>


@interface TTDatabaseCoreData : NSObject <TTDatabase>

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *timetrackerDB;

@end
