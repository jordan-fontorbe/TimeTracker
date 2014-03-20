//
//  Time.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTime.h"

@interface TTTime ()

- (void)duration;

@end

@implementation TTTime

@synthesize identifier = _identifier;
@synthesize idTask = _idTask;
@synthesize start = _start;
@synthesize end = _end;
@synthesize startComponents = _startComponents;
@synthesize endComponents = _endComponents;
@synthesize durationComponents = _durationComponents;

- (id)initWithTime:(TTTime *)time
{
    return [self initWithIdentifier:[time identifier] start:[time start] end:[time end] task:[time idTask]];
}

- (id)initWithIdentifier:(int)identifier start:(NSDate *)start end:(NSDate *)end task:(int)idTask
{
    self = [super init];
    if(self) {
        _identifier = identifier;
        _idTask = idTask;
        [self setStart:start];
        [self setEnd:end];
    }
    return nil;
}

- (id)initWithStart:(NSDate *)start end:(NSDate *)end task:(int)idTask
{
    return [self initWithIdentifier:0 start:start end:end task:idTask];
}

- (void)setStart:(NSDate *)start
{
    _start = start;
    if(start != nil) {
    _startComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:start];
    } else {
        _startComponents = nil;
    }
    [self duration];
}

- (void)setEnd:(NSDate *)end
{
    _end = end;
    if(end != nil) {
    _endComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:end];
    } else {
        _endComponents = nil;
    }
    [self duration];
}

- (NSString *)formatDay
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:NSLocalizedString(@"dd/MM/YY", @"Date format")];
    return [f stringFromDate:_start];
}

- (NSString *)formatInterval
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm"];
    NSString *s1 = [f stringFromDate:_start];
    NSString *s2 = _end == nil ? NSLocalizedString(@"Now", @"Now") : [f stringFromDate:_end];
    return [NSString stringWithFormat:@"%@ - %@", s1, s2];
}

- (NSString *)formatDuration
{
    return [NSString stringWithFormat:NSLocalizedString(@"%02d:%02d:%02d", @"Duration"), [_durationComponents hour], [_durationComponents minute], [_durationComponents second]];
}

- (void)duration
{
    if(_start != nil && _end != nil) {
        _durationComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:_start toDate:_end options:0];
    } else {
        _durationComponents = nil;
    }
}

@end
