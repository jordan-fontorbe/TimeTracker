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

@interface TTEditProjectController ()

@property (strong, nonatomic) TTProject *project;
@property (strong, nonatomic) UITextField *nameTextField;
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
    [_nameTextField resignFirstResponder];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(_nameTextField == nil) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(24, 12, 282, 21)];            [_nameTextField setFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]]];
        [_nameTextField setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_nameTextField setAdjustsFontSizeToFitWidth:NO];
        [_nameTextField setTextAlignment:NSTextAlignmentLeft];
        [_nameTextField setClearButtonMode:UITextFieldViewModeAlways];
        [_nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_nameTextField setReturnKeyType:UIReturnKeyDone];
        [_nameTextField setRightViewMode:UITextFieldViewModeAlways];
        [_nameTextField setText:[_project name]];
        [_nameTextField setDelegate:self];
    }
    [cell addSubview:_nameTextField];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
