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

@interface TTTasksListController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
- (NSMutableArray *)getTasksFor:(int)section;
- (TTTask *)getTaskFor:(int)section row:(int)row;
- (int)getProjectIdFor:(int)section;

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
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
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

- (NSArray *)getProjects
{
    return nil;
}

- (NSMutableDictionary *)getTasks
{
    return nil;
}

#pragma mark - Table view data source

- (NSMutableArray *)getTasksFor:(int)section
{
    int index = 0;
    if(section != 0) {
        index = [(TTProject *)[[self getProjects] objectAtIndex:section-1] identifier];
    }
    NSNumber *n = [NSNumber numberWithInt:index];
    NSMutableDictionary *t = [self getTasks];
    NSMutableArray *a = [t objectForKey:n];
    if(a == nil) {
        a = [[NSMutableArray alloc] init];
        [t setObject:a forKey:n];
    }
    return a;
}

- (TTTask *)getTaskFor:(int)section row:(int)row
{
    return [[self getTasksFor:section] objectAtIndex:row];
}

- (int)getProjectIdFor:(int)section
{
    if(section == 0) {
        return 0;
    } else {
        return [(TTProject *)[[self getProjects] objectAtIndex:section-1] identifier];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self getProjects] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getTasksFor:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Single Tasks", @"Single Tasks");
    } else {
        return [[[self getProjects] objectAtIndex:section-1] name];
    }
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
        [cell setShowsReorderControl:NO];
    } else {
        [[cell imageView] setImage:nil];
        [cell setShowsReorderControl:YES];
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Remove the task from the project array.
    NSMutableArray *a = [self getTasksFor:[fromIndexPath indexAtPosition:0]];
    TTTask *task = [a objectAtIndex:[fromIndexPath indexAtPosition:1]];
    [a removeObjectAtIndex:[fromIndexPath indexAtPosition:1]];
    // Change the project identifier.
    [task setIdProject:[self getProjectIdFor:[toIndexPath indexAtPosition:0]]];
    // Add the task to the project array.
    a = [self getTasksFor:[toIndexPath indexAtPosition:0]];
    [a insertObject:task atIndex:[toIndexPath indexAtPosition:1]];
    // Update database.
    [[TTDatabase instance] updateTask:task];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
