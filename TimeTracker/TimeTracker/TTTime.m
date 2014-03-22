//
//  Time.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTime.h"

static NSDateFormatter *dayFormat = nil;
static NSDateFormatter *intervalFormat = nil;
static NSDateFormatter *startFormat = nil;

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
    return self;
}

- (id)initWithStart:(NSDate *)start end:(NSDate *)end task:(int)idTask
{
    return [self initWithIdentifier:0 start:start end:end task:idTask];
}

- (void)setStart:(NSDate *)start
{
    _start = start;
    if(start != nil) {
    _startComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:start];
    } else {
        _startComponents = nil;
    }
    [self duration];
}

- (void)setEnd:(NSDate *)end
{
    _end = end;
    if(end != nil) {
    _endComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:end];
    } else {
        _endComponents = nil;
    }
    [self duration];
}

- (void)setDurationComponents:(NSDateComponents *)durationComponents
{
    [self setEnd:[[NSCalendar currentCalendar] dateByAddingComponents:durationComponents toDate:_start options:0]];
}

- (NSString *)formatDay
{
    if(dayFormat == nil) {
    dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setDateFormat:NSLocalizedString(@"dd/MM/YY", @"Date format")];
    }
    return [dayFormat stringFromDate:_start];
}

- (NSString *)formatInterval
{
    if(intervalFormat == nil) {
        intervalFormat = [[NSDateFormatter alloc] init];
        [intervalFormat setDateFormat:NSLocalizedString(@"HH:mm", @"Hour")];
    }
    NSString *s1 = [intervalFormat stringFromDate:_start];
    NSString *s2 = _end == nil ? NSLocalizedString(@"Now", @"Now") : [intervalFormat stringFromDate:_end];
    return [NSString stringWithFormat:@"%@ - %@", s1, s2];
}

- (NSString *)formatDuration
{
    return [NSString stringWithFormat:NSLocalizedString(@"%02d:%02d:%02d", @"Duration"), [_durationComponents hour], [_durationComponents minute], [_durationComponents second]];
}

- (NSString *)formatHourEnd
{
    return [NSString stringWithFormat:NSLocalizedString(@"%02d:%02d", @"Hour"), [_endComponents hour], [_endComponents minute]];
}

- (NSString *)formatStart
{
    if(startFormat == nil) {
        startFormat = [[NSDateFormatter alloc] init];
        [startFormat setDateFormat:NSLocalizedString(@"EEE dd. MMMM MM yyyy HH:mm", @"Complete date")];
    }
    return [startFormat stringFromDate:_start];
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
