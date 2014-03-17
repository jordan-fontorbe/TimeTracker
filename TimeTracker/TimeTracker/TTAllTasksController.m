//
//  TTAllTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTAllTasksController.h"
#import "TTDatabase.h"
#import "TTTaskCell.h"
#import "TTProject.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)getTasksFor:(int)section
{
    int index = 0;
    if(section != 0) {
        index = [(TTProject *)[_projects objectAtIndex:section-1] identifier];
    }
    NSNumber *n = [NSNumber numberWithInt:index];
    NSMutableDictionary *t = _tasks;
    NSMutableArray *a = [t objectForKey:n];
    if(a == nil) {
        a = [[NSMutableArray alloc] init];
        [t setObject:a forKey:n];
    }
    return a;
}

- (TTTask *)getTaskFor:(int)section row:(int)row
{
    return [[self getTasksFor:section] objectAtIndex:row];
}

- (int)getProjectIdFor:(int)section
{
    if(section == 0) {
        return 0;
    } else {
        return [(TTProject *)[_projects objectAtIndex:section-1] identifier];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_projects count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Single Tasks", @"Single Tasks");
    } else {
        return [[_projects objectAtIndex:section-1] name];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTaskCell *cell = (TTTaskCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

@end
