//
//  TTSelectProjectController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTSelectProjectController.h"
#import "TTSelectProjectDelegate.h"
#import "TTDatabase.h"
#import "TTProject.h"
#import "TTImageManager.h"

@interface TTSelectProjectController ()

@property int selectedProjectId;
@property (strong, nonatomic) NSArray *projects;

@end

@implementation TTSelectProjectController

@synthesize delegate;

- (id)initWithSelectedProject:(int)selectedProjectId
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self) {
        _selectedProjectId = selectedProjectId;
        _projects = [[TTDatabase instance] getProjects];
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
    [[TTDatabase instance] getProjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else {
        return [_projects count];
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
        // Single tasks section.
        [[cell textLabel] setText:NSLocalizedString(@"Single Tasks", @"Single tasks project name")];
        [[cell imageView] setImage:[TTImageManager getIcon:Task]];
        if(_selectedProjectId == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    } else {
        // Project section.
        TTProject *p = [_projects objectAtIndex:[indexPath indexAtPosition:1]];
        [[cell textLabel] setText:[p name]];
        [[cell imageView] setImage:[TTImageManager getIcon:Project]];
        if(_selectedProjectId == [p identifier]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    return cell;
}

 #pragma mark - Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if([indexPath indexAtPosition:0]) {
         _selectedProjectId = 0;
     } else {
         _selectedProjectId = [indexPath indexAtPosition:1] + 1;
     }
     [delegate onProjectSelected:_selectedProjectId];
     [[self navigationController] popViewControllerAnimated:YES];
 }

@end
