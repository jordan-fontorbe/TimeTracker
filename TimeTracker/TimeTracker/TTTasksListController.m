//
//  TTAllTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTasksListController.h"
#import "TTEditTaskController.h"
#import "TTDatabase.h"
#import "TTTaskCell.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTImageManager.h"
#import "TTHistoryController.h"

@interface TTTasksListController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIBarButtonItem *totalTimeButton;
- (void)setToolbar;
- (void)activateTimer;
- (void)deactivateTimer;
- (NSString *)getTotalTime;
- (NSMutableArray *)getTasksFor:(int)section;
- (TTTask *)getTaskFor:(int)section row:(int)row;
- (int)getProjectIdFor:(int)section;
- (void)onNewTask:(UIBarButtonItem *)sender;
- (TTEditTaskController *)newTaskView:(TTTask *)task;

@end

@implementation TTTasksListController

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
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
    [[self tableView] setAllowsSelectionDuringEditing:YES];
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setToolbarHidden:NO];
    [self setToolbar];
    [self activateTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deactivateTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setToolbar
{
    UIBarButtonItem *newTaskButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewTask:)];
    _totalTimeButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:newTaskButton, flexibleSpace, _totalTimeButton, flexibleSpace, nil]];
}

- (void)activateTimer
{
    [self reloadData];
    if(![self isEditing]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    }
}

- (void)deactivateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)reloadData
{
    [_totalTimeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Total : %@", @"Total time"), [self getTotalTime]]];
    [[self tableView] reloadData];
}

- (NSString *)getTotalTime
{
    return nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing) {
        [self deactivateTimer];
    } else {
        [self activateTimer];
    }
    [[self tableView] reloadData];
}

#pragma mark - Bar button items

- (void)onNewTask:(UIBarButtonItem *)sender
{
    TTEditTaskController *view = [self newTaskView:nil];
    [view setDelegate:self];
    [[self navigationController] pushViewController:view animated:YES];
}

- (TTEditTaskController *)newTaskView:(TTTask *)task
{
    return nil;
}

#pragma mark - Edit task view delegate

- (void)onCancel
{
    // Nothing modified.
}

- (void)onCancel:(TTRunningTask *)runningTask
{
    // Nothing modified.
}

- (void)onSave:(TTTask *)original :(TTTask *)modified
{
    // Task changed, insert/update and reload the table.
    if(original) {
        [[TTDatabase instance] updateTask:modified];
    } else {
        [[TTDatabase instance] insertTask:modified];
    }
    [self reloadData];
}

- (void)onSave:(TTRunningTask *)runningTask
{
    // Nothing modified.
}

#pragma mark - Table view data source

- (NSMutableArray *)getTasksFor:(int)section
{
    return nil;
}

- (TTTask *)getTaskFor:(int)section row:(int)row
{
    return nil;
}

- (int)getProjectIdFor:(int)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getTasksFor:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTTaskCell";
    static UIColor *defaultColor = nil;
    TTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TTTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    if(defaultColor == nil) {
        defaultColor = [[cell detailTextLabel] textColor];
    }
    
    TTTask *task = [self getTaskFor:[indexPath indexAtPosition:0] row:[indexPath indexAtPosition:1]];
    
    [[cell label] setText:[task name]];    [[cell time] setText:[[TTDatabase instance] getTotalTaskTimeStringFormatted:[task identifier]]];
    if (!tableView.editing) {
        if([[TTDatabase instance] isTaskRunning:[task identifier]]) {
            [[cell time] setTextColor:[UIColor redColor]];
            [[cell imageView] setImage:[TTImageManager getIcon:Pause]];
        } else {
            [[cell time] setTextColor:defaultColor];
            [[cell imageView] setImage:[TTImageManager getIcon:Play]];
        }
    } else {
        [[cell imageView] setImage:nil];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TTTask *task = [self getTaskFor:[indexPath indexAtPosition:0] row:[indexPath indexAtPosition:1]];
        [[TTDatabase instance] deleteTask:task];
        [self reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    TTTask *task = [self getTaskFor:[fromIndexPath indexAtPosition:0] row:[fromIndexPath indexAtPosition:1]];
    [task setIdProject:[self getProjectIdFor:[toIndexPath indexAtPosition:0]]];
    [[TTDatabase instance] updateTask:task];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTTask *task = [self getTaskFor:[indexPath indexAtPosition:0] row:[indexPath indexAtPosition:1]];
    if(!tableView.editing) {
        // Play/Pause the task.
        [[TTDatabase instance] runTask:[task identifier]];
        [self reloadData];
    } else {
        // Edit the task.
        TTEditTaskController *view = [[TTEditTaskController alloc] initWithTask:task];
        [view setDelegate:self];
        [[self navigationController] pushViewController:view animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(!tableView.editing) {
        // Show task history.
        TTTask *task = [self getTaskFor:[indexPath indexAtPosition:0] row:[indexPath indexAtPosition:1]];
        TTHistoryController *view = [[TTHistoryController alloc] initWithTask:[task identifier]];
        [[self navigationController] pushViewController:view animated:YES];
    }
}

@end
