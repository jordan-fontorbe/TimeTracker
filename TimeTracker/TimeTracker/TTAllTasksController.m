//
//  TTAllTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTAllTasksController.h"
#import "TTDatabase.h"

@interface TTAllTasksController ()

@property (strong, nonatomic) NSArray *projects;
@property (strong, nonatomic) NSMutableDictionary *tasks;

@end

@implementation TTAllTasksController

- (id)init
{
    self = [super init];
    if (self) {
        [self setTitle:NSLocalizedString(@"All Tasks", @"AllTasks navigation title")];
        _projects = [[TTDatabase instance] getProjects];
        NSDictionary *d = [[TTDatabase instance] getTasks];
        _tasks = [[NSMutableDictionary alloc] initWithDictionary: d];
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
