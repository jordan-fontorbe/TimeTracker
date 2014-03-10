//
//  TTEditTaskViewController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTEditTaskController.h"
#import "TTImageManager.h"
#import "TTProject.h"
#import "TTTask.h"

@interface TTEditTaskController ()

- (void)onProjectSelected:(TTProject *)project;
@property (strong, nonatomic) TTTask *task;

@end

@implementation TTEditTaskController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil task:(TTTask *)task
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:NSLocalizedString(@"Edit", "EditTask navigation title")];
        _task = task;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil]];
    [_projectTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self onProjectSelected:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"cancel");
}

- (IBAction)onSave:(id)sender {
    NSLog(@"save");
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
