//
//  TimeTrackerDatabaseDebug.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDatabaseDebug.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTime.h"

@implementation TTDatabaseDebug

- (TTTask *)getTask:(int)identifier
{
    return nil;
}

- (TTTime *)getTime:(int)identifier
{
    return nil;
}

- (TTProject *)getProject:(int)identifier
{
    return nil;
}

- (TTTask *)insertTask:(TTTask *)newTask
{
    return nil;
}
- (TTTime *)insertTime:(TTTime *)newTime
{
    return nil;
}
- (TTProject *)insertProject:(TTProject *)newProject
{
    return nil;
}

- (TTTask *)updateTask:(TTTask *)updateTask
{
    return nil;
}
- (TTTime *)updateTime:(TTTime *)updateTime
{
    return nil;
}
- (TTProject *)updateProject:(TTProject *)updateProject
{
    return nil;
}

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to
{
    return nil;
}

@end
