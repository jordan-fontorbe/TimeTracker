//
//  TTRunningTask.h
//  TimeTracker
//
//  Created by Lion User on 16/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTask.h"

@interface TTRunningTask : NSObject

@property TTTask *task;
@property NSDate *start;

- (id)initWithTask:(TTTask*)task start:(NSDate *)start;

- (NSString *)getRunningTaskTimeStringFormatted;

@end
