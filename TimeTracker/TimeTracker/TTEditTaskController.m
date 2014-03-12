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
#import "TTProject.h"
#import "TTImageManager.h"

@interface TTEditTaskController ()

@property (strong, nonatomic) TTTask *task;
@property (strong, nonatomic) TTProject *project;
@property (strong, nonatomic) UITextField *nameTextField;
- (void)onCancel:(UIBarButtonItem *)sender;
- (void)onSave:(UIBarButtonItem *)sender;

@end

@implementation TTEditTaskController

@synthesize delegate;

- (id)initWithTask:(TTTask *)task
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        if(task) {
            _task = task;
        } else {
            _task = [[TTTask alloc] initWithName:@"" project:0];
        }
        if([_task idProject] != 0) {
            _project = [[TTDatabase instance] getProject:[task idProject]];
        } else {
            _project = nil;
        }
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
    [delegate onCancel];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSave:(UIBarButtonItem *)sender {
    [delegate onSave:_task];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onProjectSelected:(int)projectId
{
    [_task setIdProject:projectId];
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
    [_task setName:[textField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameTextField resignFirstResponder];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([indexPath indexAtPosition:0] == 0) {
        if(_nameTextField == nil) {
            _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 13, 375, 30)];
            [_nameTextField setFont:[UIFont boldSystemFontOfSize:17.0]];
            [_nameTextField setAdjustsFontSizeToFitWidth:NO];
            [_nameTextField setTextAlignment:NSTextAlignmentLeft];
            [_nameTextField setClearButtonMode:UITextFieldViewModeAlways];
            [_nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [_nameTextField setReturnKeyType:UIReturnKeyDone];
            [_nameTextField setText:[_task name]];
            [_nameTextField setDelegate:self];
        }
        [cell addSubview:_nameTextField];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        if(_project) {
            [[cell textLabel] setText:[_project name]];
            [[cell imageView] setImage:[TTImageManager getIcon:Project]];
        } else {
            [[cell textLabel] setText:NSLocalizedString(@"Single Tasks", @"Single Tasks")];
            [[cell imageView] setImage:[TTImageManager getIcon:Task]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath indexAtPosition:0] == 1) {
        TTSelectProjectController *selectProjectController = [[TTSelectProjectController alloc] initWithProject:[_task idProject]];
        [selectProjectController setDelegate:self];
        [[self navigationController] pushViewController:selectProjectController animated:YES];
    }
}

@end
