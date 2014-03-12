//
//  Time.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTime.h"

@implementation TTTime

@synthesize identifier = _identifier;
@synthesize idTask = _idTask;
@synthesize start = _start;
@synthesize end = _end;

- (id)initWithIdentifier:(int)identifier start:(NSDate *)start end:(NSDate *)end task:(int)idTask
{
    self = [super init];
    if(self) {
        _identifier = identifier;
        _idTask = idTask;
        _start = start;
        _end = end;
    }
    return nil;
}

- (id)initWithStart:(NSDate *)start end:(NSDate *)end task:(int)idTask
{
    return [self initWithIdentifier:0 start:start end:end task:idTask];
}

@end
