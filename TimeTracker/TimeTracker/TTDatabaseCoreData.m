//
//  TimeTrackerDatabaseCoreData.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDatabaseCoreData.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTime.h"

@implementation TTDatabaseCoreData

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

- (NSArray *)getProjects
{
    return nil;
}

- (NSArray *)getTasks
{
    return nil;
}

- (void)insertTask:(TTTask *)newTask
{
}

- (void)insertTime:(TTTime *)newTime
{
}

- (void)insertProject:(TTProject *)newProject
{
}

- (void)updateTask:(TTTask *)updateTask
{
}
- (void)updateTime:(TTTime *)updateTime
{
}
- (void)updateProject:(TTProject *)updateProject
{
}

- (void)deleteProject:(TTProject *)project
{
}

- (void)deleteTask:(TTTask *)task
{
}

- (void)deleteTime:(TTTime *)time
{
}

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project
{
    return nil;
}

@end
