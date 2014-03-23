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

@interface TTRunningTask : TTTime

@property TTTask *task;

- (id)initWithTask:(TTTask*)task start:(NSDate *)start;

- (NSString *)getRunningTaskTimeStringFormatted;
- (void)save;

@end
