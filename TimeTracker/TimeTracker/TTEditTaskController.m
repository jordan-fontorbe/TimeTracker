//
//  TTEditTaskViewController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTEditTaskController.h"
#import "TTEditTaskDelegate.h"
#import "TTImageManager.h"
#import "TTProject.h"
#import "TTTask.h"

@interface TTEditTaskController ()

- (void)onCancel:(UIBarButtonItem *)sender;
- (void)onSave:(UIBarButtonItem *)sender;
- (void)onProjectSelected:(TTProject *)project;
@property (strong, nonatomic) TTTask *task;

@end

@implementation TTEditTaskController

@synthesize delegate;
@synthesize task = _task;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil task:(TTTask *)task
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:NSLocalizedString(@"Edit", @"EditTask navigation title")];
        _task = task;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Navigation bar.
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)]];
    // Name field.
    [_nameTextField setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [_nameTextField setRightViewMode:UITextFieldViewModeAlways];
    [_table setDelegate:self];
    [_table setDataSource:self];
    [_table reloadData];
    // Project field.
    /*[_projectTextField setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [_projectTextField setEnabled:NO];
    [_projectTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_projectTextField setRightViewMode:UITextFieldViewModeAlways];
    [_projectTextField setRightView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    // Update selected project.
    [self onProjectSelected:nil];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel:(UIBarButtonItem *)sender
{
    [delegate onCancel:self];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSave:(UIBarButtonItem *)sender {
    [delegate onCancel:self];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    [[cell textLabel] setText:@"Single Project"];
    return cell;
}

- (void)onProjectSelected:(TTProject *)project
{
    if (project == nil || [project identifier] <= 0) {
        // No project = single task.
        [_projectTextField setLeftView:[TTImageManager getIconView:Task]];
        [_projectTextField setText:@"Single Tasks"];
    } else {
        // Project.
        [_projectTextField setLeftView:[TTImageManager getIconView:Project]];
        [_projectTextField setText:[project name]];
    }
}

@end
