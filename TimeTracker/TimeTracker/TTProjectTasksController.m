//
//  TTProjectTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTProjectTasksController.h"
#import "TTEditTaskController.h"
#import "TTDatabase.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTaskCell.h"

@interface TTProjectTasksController ()

@property int project;
@property (strong, nonatomic) NSMutableArray *tasks;

@end

@implementation TTProjectTasksController

- (id)initWithProject:(int)project
{
    self = [super init];
    if (self) {
        if(project == 0) {
            [self setTitle:NSLocalizedString(@"Single Tasks", @"Single Tasks")];
        } else {
            [self setTitle:[[[TTDatabase instance] getProject: project] name]];
        }
        _project = project;
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

- (TTEditTaskController *)newTaskView:(TTTask *)task
{
    return [[TTEditTaskController alloc] initWithTask:task forProject:_project];
}

- (void)reloadData
{
    NSArray *a = [[TTDatabase instance] getTasksFor: _project];
    _tasks = [[NSMutableArray alloc] initWithArray:a];
    [super reloadData];
}

- (NSString *)getTotalTime
{
    return [[TTDatabase instance] getTotalProjectTimeStringFormatted:_project];
}

- (NSMutableArray *)getTasksFor:(int)section
{
    return _tasks;
}

- (TTTask *)getTaskFor:(int)section row:(int)row
{
    return [_tasks objectAtIndex:row];
}

- (int)getProjectIdFor:(int)section
{
    return _project;
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
