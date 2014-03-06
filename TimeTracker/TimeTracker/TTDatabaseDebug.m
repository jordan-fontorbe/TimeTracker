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

@interface TTDatabaseDebug ()

@property int nextProjectIdentifier;
@property int nextTaskIdentifier;
@property int nextTimeIdentifier;
@property (strong, nonatomic) NSMutableDictionary *projects;
@property (strong, nonatomic) NSMutableDictionary *tasks;
@property (strong, nonatomic) NSMutableDictionary *times;

@end

@implementation TTDatabaseDebug

- (id)init
{
    if(self == [super init]) {
        _nextProjectIdentifier = 1;
        _nextTaskIdentifier = 1;
        _nextTimeIdentifier = 1;
        return self;
    } else {
        return nil;
    }
}

- (TTProject *)getProject:(int)identifier
{
    return [_projects objectForKey:[NSNumber numberWithInt:identifier]];
}

- (TTTask *)getTask:(int)identifier
{
    return [_tasks objectForKey:[NSNumber numberWithInt:identifier]];
}

- (TTTime *)getTime:(int)identifier
{
    return [_times objectForKey:[NSNumber numberWithInt:identifier]];
}

- (NSArray *)getProjects
{
    return [_projects allValues];
}

- (NSArray *)getTasks
{
    return [_tasks allValues];
}

- (void)insertProject:(TTProject *)newProject
{
    [newProject setIdentifier:_nextProjectIdentifier];
    [_projects setObject:newProject forKey:[NSNumber numberWithInt:_nextProjectIdentifier]];
    ++_nextProjectIdentifier;
}

- (void)insertTask:(TTTask *)newTask
{
    [newTask setIdentifier:_nextTaskIdentifier];
    [_projects setObject:newTask forKey:[NSNumber numberWithInt:_nextTaskIdentifier]];
    ++_nextTaskIdentifier;
}

- (void)insertTime:(TTTime *)newTime
{
    [newTime setIdentifier:_nextTimeIdentifier];
    [_projects setObject:newTime forKey:[NSNumber numberWithInt:_nextTimeIdentifier]];
    ++_nextTimeIdentifier;
}

- (void)updateProject:(TTProject *)updateProject
{
    [_projects setObject:updateProject forKey:[NSNumber numberWithInt:[updateProject identifier]]];
}

- (void)updateTask:(TTTask *)updateTask
{
    [_tasks setObject:updateTask forKey:[NSNumber numberWithInt:[updateTask identifier]]];
}

- (void)updateTime:(TTTime *)updateTime
{
    [_times setObject:updateTime forKey:[NSNumber numberWithInt:[updateTime identifier]]];
}

- (void)deleteProject:(TTProject *)project
{
    [_projects removeObjectForKey:[NSNumber numberWithInt:[project identifier]]];
}

- (void)deleteTask:(TTTask *)task
{
    [_tasks removeObjectForKey:[NSNumber numberWithInt:[task identifier]]];
}

- (void)deleteTime:(TTTime *)time
{
    [_times removeObjectForKey:[NSNumber numberWithInt:[time identifier]]];
}

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project
{
    return nil;
}

@end
