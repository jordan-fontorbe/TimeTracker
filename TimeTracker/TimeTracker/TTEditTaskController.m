//
//  TTEditTaskController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTEditTaskController.h"
#import "TTEditTaskDelegate.h"
#import "TTSelectProjectController.h"
#import "TTDatabase.h"
#import "TTTask.h"
#import "TTRunningTask.h"
#import "TTProject.h"
#import "TTImageManager.h"
#import "TTTextFieldCell.h"

@interface TTEditTaskController ()

@property (strong, nonatomic) TTTask *task;
@property (strong, nonatomic) TTTask *taskTmp;
@property (strong, nonatomic) TTProject *project;
@property (weak, nonatomic) TTTextFieldCell *name;
@property (strong, nonatomic) TTRunningTask *runningTask;
- (void)onCancel:(UIBarButtonItem *)sender;
- (void)onSave:(UIBarButtonItem *)sender;

@end

@implementation TTEditTaskController

@synthesize delegate;

- (id)initWithTask:(TTTask *)task
{
    return [self initWithTask:task forProject:0];
}

- (id)initWithTask:(TTTask *)task forProject:(int)project
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        _runningTask = nil;
        if(task) {
            _task = task;
            _taskTmp = [[TTTask alloc] initWithTask:task];
            [self setTitle:NSLocalizedString(@"Edit", @"EditTask navigation title")];
        } else {
            _task = nil;
            _taskTmp = [[TTTask alloc] initWithName:@"" project:project];
            [self setTitle:NSLocalizedString(@"New Task", @"EditTask navigation title")];
        }
        if([_taskTmp idProject] != 0) {
            _project = [[TTDatabase instance] getProject:[_taskTmp idProject]];
        } else {
            _project = nil;
        }
    }
    return self;
}

- (id)initWithRunningTask:(TTRunningTask *)runningTask
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        _task = nil;
        _taskTmp = [[TTTask alloc] initWithTask:[runningTask task]];
        _runningTask = runningTask;
        if ([[runningTask task] idProject] > 0) {
            _project = [[TTDatabase instance] getProject:[[runningTask task] idProject]];
        } else {
            _project = nil;
        }
        [self setTitle:NSLocalizedString(@"Edit", @"EditTask navigation title")];
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
    // Navigation bar.
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onCancel:(UIBarButtonItem *)sender
{
    
    if (_runningTask != nil) {
        [delegate onCancel:_runningTask];
    }
    else {
        [delegate onCancel];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSave:(UIBarButtonItem *)sender {
    if (_runningTask != nil) {
        [_runningTask setTask:_taskTmp];
        [delegate onSave:_runningTask];
    } else {
        [delegate onSave:_task :_taskTmp];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onProjectSelected:(int)projectId
{
    [_taskTmp setIdProject:projectId];
    if(projectId == 0) {
        _project = nil;
    } else {
        _project = [[TTDatabase instance] getProject:projectId];
    }
    [[self tableView] reloadData];
}

#pragma mark - Text field view delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_taskTmp setName:[textField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_name.textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return nil;
    } else {
        return NSLocalizedString(@"Project", @"Project");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath indexAtPosition:0] == 0) {
        if(_name == nil) {
            _name = [[[NSBundle mainBundle] loadNibNamed:@"TTTextFieldCell" owner:self options:nil] objectAtIndex:0];
            UITextField *text = [_name textField];
            [text setRightViewMode:UITextFieldViewModeAlways];
            [text setText:[_taskTmp name]];
            [text setDelegate:self];
        }
        [_name setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_name setAccessoryType:UITableViewCellAccessoryNone];
        return _name;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(_project) {
            [[cell textLabel] setText:[_project name]];
            [[cell imageView] setImage:[TTImageManager getIcon:Project]];
        } else {
            [[cell textLabel] setText:NSLocalizedString(@"Single Tasks", @"Single Tasks")];
            [[cell imageView] setImage:[TTImageManager getIcon:Task]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath indexAtPosition:0] == 1) {
        TTSelectProjectController *selectProjectController = [[TTSelectProjectController alloc] initWithProject:[_taskTmp idProject]];
        [selectProjectController setDelegate:self];
        [[self navigationController] pushViewController:selectProjectController animated:YES];
    }
}

@end
