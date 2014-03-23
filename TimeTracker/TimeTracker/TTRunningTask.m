//
//  TTRunningTask.m
//  TimeTracker
//
//  Created by Lion User on 16/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTRunningTask.h"
#import "TTDatabase.h"
#import "TTTask.h"

@implementation TTRunningTask

@synthesize task = _task;

- (id)initWithTask:(TTTask*)task start:(NSDate *)start
{
    self = [super initWithStart:start end:nil task:[task identifier]];
    if(self) {
        _task = task;
    }
    return self;
}

- (NSString *)getRunningTaskTimeStringFormatted
{
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:[self start]];
    if ([self end] != nil) {
        diff = [[self end] timeIntervalSinceDate:[self start]];
    }
    
    NSUInteger seconds = (NSUInteger)round(diff);
    NSString *res = [NSString stringWithFormat:@"%02u:%02u:%02u", seconds / 3600, (seconds / 60) % 60, seconds % 60];
    return res;
}

- (void)save
{
    if ([_task identifier] == 0) {
        [[TTDatabase instance] insertTask:_task];
    }
    if ([_task identifier] > 0) { // tache insérée
        NSDate *startTmp = [self start];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSUInteger componentFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *componentsStart = [[NSCalendar currentCalendar] components:componentFlags fromDate:startTmp];
        NSDateComponents *componentsEnd = [[NSCalendar currentCalendar] components:componentFlags fromDate:[self end]];
        
        // on split par jour
        while ([componentsStart year] != [componentsEnd year] || [componentsStart month] != [componentsEnd month] || [componentsStart day] != [componentsEnd day]) {
            TTTime *time = [[TTTime alloc] init];
            [time setIdTask:[_task identifier]];
            [time setStart:startTmp];
            [time setEnd:[dateFormat dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d 23:59:59", [componentsStart year], [componentsStart month], [componentsStart day]]]];
            [[TTDatabase instance] insertTime:time];
            startTmp = [startTmp dateByAddingTimeInterval:60*60*24];
            componentsStart = [[NSCalendar currentCalendar] components:componentFlags fromDate:startTmp];
            startTmp = [dateFormat dateFromString:[NSString stringWithFormat:@"%04d-%02d-%02d 00:00:00", [componentsStart year], [componentsStart month], [componentsStart day]]];
        }
        TTTime *time = [[TTTime alloc] init];
        [time setIdTask:[_task identifier]];
        [time setStart:startTmp];
        [time setEnd:[self end]];
        [[TTDatabase instance] insertTime:time];
    }
}

@end
