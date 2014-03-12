//
//  TimeTrackerDatabaseCoreData.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTDatabaseProtocol.h"
#import <sqlite3.h>


@interface TTDatabase : NSObject <TTDatabaseProtocol>

+(TTDatabase*)instance;

@end
