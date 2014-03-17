//
//  TTProjectTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTProjectTasksController.h"
#import "TTDatabase.h"
#import "TTProject.h"

@interface TTProjectTasksController ()

@property (strong, nonatomic) NSArray *projects;
@property (strong, nonatomic) NSMutableDictionary *tasks;

@end

@implementation TTProjectTasksController

- (id)initWithProject:(int)project
{
    self = [super init];
    if (self) {
        TTProject *p = [[TTDatabase instance] getProject:project];
        _projects = [[NSMutableArray alloc] initWithObjects:p, nil];
        NSArray *d = [[TTDatabase instance] getTasksFor: project];
        _tasks = [[NSMutableDictionary alloc] init];
        [_tasks setObject:d forKey:[NSNumber numberWithInt: project]];
        [self setTitle:[p name]];
    }
    return self;
}

- (NSArray *)getProjects
{
    return _projects;
}

- (NSMutableDictionary *)getTasks
{
    return _tasks;
}

@end
