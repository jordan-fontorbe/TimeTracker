//
//  TTSelectTaskController.m
//  TimeTracker
//
//  Created by Lion User on 21/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTSelectTaskController.h"
#import "TTSelectTaskDelegate.h"
#import "TTDatabase.h"
#import "TTProject.h"
#import "TTTask.h"

@interface TTSelectTaskController ()

@property (strong, nonatomic) NSDictionary *tasks;
@property (strong, atomic) TTRunningTask *runningTask;

@end

@implementation TTSelectTaskController

@synthesize delegate;

- (id)initWithRunningTask:(TTRunningTask *)runningTask
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _tasks = [[TTDatabase instance] getTasks];
        _runningTask = runningTask;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)]];
}

- (void)onCancel:(UIBarButtonItem *)sender
{
    [delegate onCancel:_runningTask];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_tasks allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *lstTasks = [[_tasks allValues] objectAtIndex:section];
    return [lstTasks count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *lstTasks = [[_tasks allValues] objectAtIndex:section];
    TTTask *task = [lstTasks objectAtIndex:0];
    
    if ([task idProject] == 0) {
        return NSLocalizedString(@"Single Tasks", @"Single Tasks");
    } else {
        TTProject *project = [[TTDatabase instance] getProject:[task idProject]];
        return [project name];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // On récupère la liste de taches pour la section
    NSMutableArray *lstTasks = [[_tasks allValues] objectAtIndex:indexPath.section];
    TTTask *task = [lstTasks objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[task name]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *lstTasks = [[_tasks allValues] objectAtIndex:indexPath.section];
    TTTask *task = [lstTasks objectAtIndex:indexPath.row];
    [delegate onTaskSelected:[task identifier] :_runningTask];
    [[self navigationController] popViewControllerAnimated:YES];
}



@end
