//
//  TTRunningTask.m
//  TimeTracker
//
//  Created by Lion User on 16/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTRunningTask.h"

@implementation TTRunningTask

@synthesize task = _task;
@synthesize start = _start;

- (id)initWithTask:(TTTask*)task start:(NSDate *)start
{
    self = [super init];
    if(self) {
        _task = task;
        _start = start;
    }
    return self;
}

- (NSString *)getRunningTaskTimeStringFormatted
{
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:_start];
    
    NSUInteger seconds = (NSUInteger)round(diff);
    NSString *res = [NSString stringWithFormat:@"%02u:%02u:%02u", seconds / 3600, (seconds / 60) % 60, seconds % 60];
    return res;
}

@end
