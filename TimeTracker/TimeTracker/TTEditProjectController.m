//
//  TTEditProjectController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTEditProjectController.h"
#import "TTEditProjectDelegate.h"
#import "TTDatabase.h"
#import "TTProject.h"
#import "TTTextFieldCell.h"

@interface TTEditProjectController ()

@property (strong, nonatomic) TTProject *project;
@property (weak, nonatomic) TTTextFieldCell *name;
- (void)onCancel:(UIBarButtonItem *)sender;
- (void)onSave:(UIBarButtonItem *)sender;

@end

@implementation TTEditProjectController

@synthesize delegate;

- (id)initWithProject:(TTProject *)project
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        if(project) {
            _project = project;
            [self setTitle:NSLocalizedString(@"Edit", @"EditProject navigation title")];
        } else {
            _project = [[TTProject alloc] initWithName:@""];
            [self setTitle:NSLocalizedString(@"New Project", @"EditProject navigation title")];
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
    [delegate onSave:_project];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Text field view delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_project setName:[textField text]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_name.textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

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
    if(_name == nil) {
        _name = [[[NSBundle mainBundle] loadNibNamed:@"TTTextFieldCell" owner:self options:nil] objectAtIndex:0];
        UITextField *text = [_name textField];
        [text setRightViewMode:UITextFieldViewModeAlways];
        [text setText:[_project name]];
        [text setDelegate:self];
    }
    [_name setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_name setAccessoryType:UITableViewCellAccessoryNone];
    return _name;}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
