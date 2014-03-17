//
//  TTOverviewController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTOverviewController.h"
#import "TTAboutController.h"
#import "TTEditTaskController.h"
#import "TTDataManager.h"
#import "TTDatabase.h"
#import "TTProject.h"
#import "TTTask.h"
#import "QuartzCore/QuartzCore.h"
#import "TTSelectProjectController.h"
#import "TTRunningTask.h"
#import "TTImageManager.h"
#import "TTTaskCell.h"
#import "TTAllTasksController.h"
#import "TTProjectTasksController.h"

@interface TTOverviewController ()

- (void)onAbout:(UIBarButtonItem *)sender;

@end

@implementation TTOverviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:NSLocalizedString(@"Overview", @"Overview navigation title")];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *aboutButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", @"Overview navigation left button title") style:UIBarButtonSystemItemAdd target:self action:@selector(onAbout:)];
    [[self navigationItem] setLeftBarButtonItem:aboutButtonItem];
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    self.btnQuickStart.layer.cornerRadius = 10;
    self.btnQuickStart.layer.borderWidth = 1;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableViewForTimer) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[[TTDataManager instance] getRunningTasks] count];
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return [[[TTDatabase instance] getProjects] count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TTTaskCell";
    TTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TTTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    if (indexPath.section != 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [[cell viewWithTag:222] removeFromSuperview];
    
    if (indexPath.section == 0) {
        NSMutableArray *lstRunningTasks = [[TTDataManager instance] getRunningTasks];
        if (lstRunningTasks.count > indexPath.row)
        {
            TTRunningTask *myRunningTask = (TTRunningTask *)[lstRunningTasks objectAtIndex:indexPath.row];
            if ([[myRunningTask task] identifier] > 0){
                [[cell imageView] setImage:[TTImageManager getIcon:Pause]];
                cell.label.text = [[myRunningTask task] name];
                TTProject *myProject = [[TTDatabase instance] getProject:[[myRunningTask task] idProject]];
                if (myProject != nil){
                    cell.detailTextLabel.text = [myProject name];
                }
            }
            else {
                [[cell imageView] setImage:[TTImageManager getIcon:QuickStart]];
                cell.label.text = @"Quick Task";
            }
            
            cell.time.text = [myRunningTask getRunningTaskTimeStringFormatted];
        }
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [[cell imageView] setImage:[TTImageManager getIcon:Tasks]];
            cell.label.text = @"All Tasks";
            cell.time.text = [[TTDatabase instance] getTotalTimeStringFormatted];
        }
        else if (indexPath.row == 1) {
            [[cell imageView] setImage:[TTImageManager getIcon:Task]];
            cell.label.text = @"Single Tasks";
            cell.time.text = [[TTDatabase instance] getTotalProjectTimeStringFormatted:0];
            
        }
        // [[cell contentView] addSubview:myTimeLabel];
    }
    else if (indexPath.section == 2) {
        [[cell imageView] setImage:[TTImageManager getIcon:Project]];
        
        NSMutableArray *lstProject = [NSMutableArray arrayWithArray:[[TTDatabase instance] getProjects]];
        if (lstProject.count > indexPath.row)
        {
            TTProject *myProject = (TTProject *)[lstProject objectAtIndex:indexPath.row];
            cell.label.text = [myProject name];
            cell.time.text = [[TTDatabase instance] getTotalProjectTimeStringFormatted:[myProject identifier]];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath indexAtPosition:0]) {
        case 0:
            break;
        case 1:
        {
            if([indexPath indexAtPosition:1] == 0) {
                TTAllTasksController *view = [[TTAllTasksController alloc] init];
                [[self navigationController] pushViewController:view animated:YES];
            } else {
                TTProjectTasksController *view = [[TTProjectTasksController alloc] initWithProject:0];
                [[self navigationController] pushViewController:view animated:YES];
            }
            break;
        }
        case 2:
        {
            TTProject *p = [[TTDatabase instance] getProject:[indexPath indexAtPosition:1]+1];
            TTProjectTasksController *view = [[TTProjectTasksController alloc] initWithProject:[p identifier]];
            [[self navigationController] pushViewController:view animated:YES];
            break;
        }
        default:;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAbout:(UIBarButtonItem *)sender
{
    TTAboutController *aboutController = [[TTAboutController alloc] initWithNibName:@"TTAboutController" bundle:nil];
    [[self navigationController] pushViewController:aboutController animated:YES];
}

- (IBAction)onEditTask:(id)sender {
    TTEditTaskController *editTaskController = [[TTEditTaskController alloc] initWithTask:nil];
    [[self navigationController] pushViewController:editTaskController animated:YES];
}

- (IBAction)btnQuickStart_TouchDown:(id)sender {
    TTTask *task = [[TTTask alloc]init];
    NSMutableArray *lstRunningTasks = [[TTDataManager instance] getRunningTasks];
    NSDate *now = [NSDate date];
    TTRunningTask *runningTask = [[TTRunningTask alloc] initWithTask:task start:now];
    [lstRunningTasks addObject:runningTask];
    [[TTDataManager instance] setRunningTasks:lstRunningTasks];
    
    [self.tblView reloadData];
}

-(void)reloadTableViewForTimer {
    
    [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}
@end
