//
//  TTAllTasksController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTTasksListController.h"
#import "TTDatabase.h"
#import "TTTaskCell.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTImageManager.h"
#import "TTEditTaskController.h"

@interface TTTasksListController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (NSMutableArray *)getTasksFor:(int)section;
- (TTTask *)getTaskFor:(int)section row:(int)row;
- (int)getProjectIdFor:(int)section;
- (void)removeTask:(TTTask *)task;
- (void)addTask:(TTTask *)task;
- (void)replaceTask:(TTTask *)original :(TTTask *)modified;
- (void)onNewTask:(UIBarButtonItem *)sender;

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
    UIBarButtonItem *newTaskButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewTask:)];
    [self setToolbarItems:[NSArray arrayWithObjects:newTaskButton, nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [[self tableView] reloadData];
}

#pragma mark - Bar button items

- (void)onNewTask:(UIBarButtonItem *)sender
{
    TTEditTaskController *view = [[TTEditTaskController alloc] initWithTask:nil];
    [view setDelegate:self];
    [[self navigationController] pushViewController:view animated:YES];
}

#pragma mark - Edit task view delegate

- (void)onCancel
{
    // Nothing modified.
}

- (void)onSave:(TTTask *)original :(TTTask *)modified
{
    // Task changed, insert/update and reload the table.
    if(original) {
        [self replaceTask:original :modified];
        [[TTDatabase instance] updateTask:modified];
    } else {
        [self addTask:modified];
        [[TTDatabase instance] insertTask:modified];
    }
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (void)removeTask:(TTTask *)task
{
}

- (void)addTask:(TTTask *)task
{
}

- (void)replaceTask:(TTTask *)original :(TTTask *)modified
{
}

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
    TTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TTTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    
    TTTask *task = [self getTaskFor:[indexPath indexAtPosition:0] row:[indexPath indexAtPosition:1]];
    
    [[cell label] setText:[task name]];
    if (!tableView.editing) {
        [[cell imageView] setImage:[TTImageManager getIcon:Play]];
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
        [self removeTask:task];
        [[TTDatabase instance] deleteTask:task];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Remove the task from the project array.
    TTTask *task = [self getTaskFor:[fromIndexPath indexAtPosition:0] row:[fromIndexPath indexAtPosition:1]];
    [self removeTask:task];
    // Change the project identifier.
    [task setIdProject:[self getProjectIdFor:[toIndexPath indexAtPosition:0]]];
    // Add the task to the project array.
    NSMutableArray *a = [self getTasksFor:[toIndexPath indexAtPosition:0]];
    [a insertObject:task atIndex:[toIndexPath indexAtPosition:1]];
    // Update database.
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
        // Show task informations.
    } else {
        // Edit the task.
        TTEditTaskController *view = [[TTEditTaskController alloc] initWithTask:task];
        [view setDelegate:self];
        [[self navigationController] pushViewController:view animated:YES];
    }
}

@end
