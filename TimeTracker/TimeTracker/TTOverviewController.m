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
#import "TTEditProjectController.h"
#import "TTSelectTaskController.h"

@interface TTOverviewController ()

- (void)onAbout:(UIBarButtonItem *)sender;
- (void)showActionSheet:(id)sender; // method to show action sheet

@end

@implementation TTOverviewController

NSTimer	* _tableViewTimer;

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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:NO];
    
    [self.tblView reloadData];
    
    [self activateTimer];
    
    [self setTooBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES];
    [self deactivateTimer];
}

- (void) setTooBar
{
    UIBarButtonItem *newProjectButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewProject:)];
    
    UIBarButtonItem *totalTimeButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Total : %@", [[TTDatabase instance] getTotalTimeStringFormatted]] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *newMailButtonItem = [[UIBarButtonItem alloc] initWithImage:[TTImageManager getIcon:Mail] style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects: newProjectButtonItem, flexibleSpace, totalTimeButtonItem, flexibleSpace, newMailButtonItem, nil]];
}

- (void)activateTimer
{
    _tableViewTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableViewForTimer) userInfo:nil repeats:YES];
}

- (void)deactivateTimer
{
    [_tableViewTimer invalidate];
    _tableViewTimer = nil;
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
                cell.label.text = [[myRunningTask task] name];
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
            [self showActionSheet:indexPath];
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

- (void)onNewProject:(UIBarButtonItem *)sender
{
    TTEditProjectController *editController = [[TTEditProjectController alloc] initWithProject:nil];
    [[self navigationController] pushViewController:editController animated:YES];
}

- (IBAction)onEditTask:(id)sender {
    TTEditTaskController *editTaskController = [[TTEditTaskController alloc] initWithTask:nil];
    [[self navigationController] pushViewController:editTaskController animated:YES];
}

- (IBAction)btnQuickStart_TouchDown:(id)sender {
    TTTask *task = [[TTTask alloc]init];
    [task setName:[NSString stringWithFormat:@"Quick Task %d", [[TTDataManager instance] getNumberOfQuickRunningTasks] + 1]];
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

/** ActionSheet methods **/

// called when button inside actionsheet is clicked
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Supprimer"]) {
        [[[TTDataManager instance] getRunningTasks] removeObjectAtIndex:[actionSheet tag]];
    }
    else if ([buttonTitle isEqualToString:@"Créer une nouvelle tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getRunningTasks] objectAtIndex:[actionSheet tag]];
        TTEditTaskController *editTaskController = [[TTEditTaskController alloc] initWithRunningTask:runningTask];
        [editTaskController setDelegate:self];
        [[self navigationController] pushViewController:editTaskController animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Ajouter à une tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getRunningTasks] objectAtIndex:[actionSheet tag]];
        TTSelectTaskController *selectTaskController = [[TTSelectTaskController alloc] initWithRunningTask:runningTask];
        [selectTaskController setDelegate:self];
        [[self navigationController] pushViewController:selectTaskController animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Ajouter à la tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getRunningTasks] objectAtIndex:[actionSheet tag]];
        [runningTask save];
         [[[TTDataManager instance] getRunningTasks] removeObject:runningTask];
        [self.tblView reloadData];
        [self setTooBar];
    }
    else if ([buttonTitle isEqualToString:@"Annuler"]) {
        // On remet le end à nil puiqu'on continue la tache
        [[[[TTDataManager instance] getRunningTasks] objectAtIndex:[actionSheet tag]] setEnd:nil];
    }
}

// show actionsheet popup
- (void)showActionSheet:(id)sender
{
    NSDate *now = [NSDate date];
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    TTRunningTask *runningTask = [[[TTDataManager instance] getRunningTasks] objectAtIndex:[indexPath row]];
    [runningTask setEnd:now];
    
    UIActionSheet *actionSheet = nil;
    if ([[runningTask task] identifier] > 0) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Annuler"
                       destructiveButtonTitle:@"Ajouter à la tâche"
                       otherButtonTitles:@"Supprimer",nil];
        [actionSheet setDestructiveButtonIndex:1];
    }
    else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Annuler"
                       destructiveButtonTitle:@"Créer une nouvelle tâche"
                       otherButtonTitles:@"Ajouter à une tâche",@"Supprimer", nil];
         [actionSheet setDestructiveButtonIndex:2];
        
    }
    [actionSheet setTag:indexPath.row];
    [actionSheet showInView:self.view];
}

- (void)onSave:(id)runningTask
{
    TTRunningTask *myRunningTask = (TTRunningTask *)runningTask;
    [myRunningTask save];
    [[[TTDataManager instance] getRunningTasks] removeObject:runningTask];
}

-(void)onCancel:(TTRunningTask *)runningTask
{
    [runningTask setEnd:nil];
}

-(void)onTaskSelected:(int)taskId :(TTRunningTask *)runningTask
{
    [runningTask setTask:[[TTDatabase instance] getTask:taskId]];
    [runningTask save];
    [[[TTDataManager instance] getRunningTasks] removeObject:runningTask];
}

@end
