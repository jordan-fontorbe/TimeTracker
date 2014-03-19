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
#import "TTTask.h"
#import "TTTaskCell.h"

@interface TTProjectTasksController ()

@property (strong, nonatomic) TTProject *project;
@property (strong, nonatomic) NSMutableArray *tasks;

@end

@implementation TTProjectTasksController

- (id)initWithProject:(int)project
{
    self = [super init];
    if (self) {
        if(project == 0) {
            _project = nil;
            [self setTitle:NSLocalizedString(@"Single Tasks", @"Single Tasks")];
        } else {
            _project = [[TTDatabase instance] getProject: project];
            [self setTitle:[_project name]];
        }
        NSArray *a = [[TTDatabase instance] getTasksFor: project];
        _tasks = [[NSMutableArray alloc] initWithArray:a];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)removeTask:(TTTask *)task
{
    [_tasks removeObject:task];
}

- (void)addTask:(TTTask *)task
{
    [_tasks addObject:task];
}

- (void)replaceTask:(TTTask *)original :(TTTask *)modified
{
    int index = [_tasks indexOfObject:original];
    [_tasks removeObjectAtIndex:index];
    if([modified idProject] == [original idProject]) {
        [_tasks insertObject:modified atIndex:index];
    }
}

- (NSMutableArray *)getTasksForProject:(int)project
{
    return _tasks;
}

- (NSMutableArray *)getTasksFor:(int)section
{
    return _tasks;
}

- (TTTask *)getTaskFor:(int)section row:(int)row
{
    return [[self getTasksFor:section] objectAtIndex:row];
}

- (int)getProjectIdFor:(int)section
{
    return [_project identifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTaskCell *cell = (TTTaskCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
