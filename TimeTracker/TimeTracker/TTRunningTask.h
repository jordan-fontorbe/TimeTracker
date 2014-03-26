//
//  TTRunningTask.h
//  TimeTracker
//
//  Created by Lion User on 16/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTime.h"

@class TTTask;

/**
 Running task.
 */
@interface TTRunningTask : TTTime

/**
 Related task.
 */
@property TTTask *task;

/**
 Initialize a new running task.
 @param task Related task.
 @param start Starting date.
 @return The initialized running task.
 */
- (id)initWithTask:(TTTask*)task start:(NSDate *)start;

/**
 Get the time formatted.
 @return The time formatted.
 */
- (NSString *)getRunningTaskTimeStringFormatted;

/**
 Save the current time.
 */
- (void)save;

@end
