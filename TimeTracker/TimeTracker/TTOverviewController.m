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

@property (strong, nonatomic) UIBarButtonItem *totalTimeButtonItem;
@property (strong, nonatomic) NSArray *projects;
- (void)onAbout:(UIBarButtonItem *)sender;
- (void)showActionSheet:(id)sender; // method to show action sheet
- (void)reloadData;

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
    [[self tblView] setAllowsSelectionDuringEditing:YES];
    UIBarButtonItem *aboutButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", @"Overview navigation left button title") style:UIBarButtonSystemItemAdd target:self action:@selector(onAbout:)];
    [[self navigationItem] setLeftBarButtonItem:aboutButtonItem];
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    self.btnQuickStart.layer.cornerRadius = 10;
    self.btnQuickStart.layer.borderWidth = 1;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:NO];
    [self setTooBar];
    [self activateTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deactivateTimer];
}

- (void) setTooBar
{
    UIBarButtonItem *newProjectButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewProject:)];
    
    _totalTimeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *newMailButtonItem = [[UIBarButtonItem alloc] initWithImage:[TTImageManager getIcon:Mail] style:UIBarButtonItemStylePlain target:self action:@selector(showEmail:)];
    
    [self setToolbarItems:[NSArray arrayWithObjects: newProjectButtonItem, flexibleSpace, _totalTimeButtonItem, flexibleSpace, newMailButtonItem, nil]];
}

- (void)activateTimer
{
    [self reloadData];
    if(![self isEditing]) {
        _tableViewTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    }
}

- (void)deactivateTimer
{
    [_tableViewTimer invalidate];
    _tableViewTimer = nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing) {
        [self deactivateTimer];
    } else {
        [self activateTimer];
    }
    [[self tblView] setEditing:editing animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[TTDataManager instance] getTotalNumberOfRunningTasks];
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return [_projects count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"TTTaskCell";
    static UIColor *defaultColor = nil;
    TTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TTTaskCell" owner:self options:nil] objectAtIndex:0];
    }
    if(defaultColor == nil) {
        defaultColor = [[cell textLabel] textColor];
    }
    
    if (indexPath.section != 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [[cell viewWithTag:222] removeFromSuperview];
    
    if (indexPath.section == 0) {
        TTRunningTask *t = nil;
        if(indexPath.row < [[TTDataManager instance] getNumberOfQuickRunningTasks]) {
            // Quick running task.
            t = [[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:indexPath.row];
            [[cell imageView] setImage:[TTImageManager getIcon:QuickStart]];
            cell.label.text = [[t task] name];
        } else if(indexPath.row < [[TTDataManager instance] getTotalNumberOfRunningTasks]) {
            // Running task.
            t = [[[TTDataManager instance] getRunningTasks] objectAtIndex:indexPath.row - [[TTDataManager instance] getNumberOfQuickRunningTasks]];
            [[cell imageView] setImage:[TTImageManager getIcon:Pause]];
            cell.label.text = [[t task] name];
            TTProject *myProject = [[TTDatabase instance] getProject:[[t task] idProject]];
            if (myProject != nil){
                cell.detailTextLabel.text = [myProject name];
            }
        }
        cell.time.text = [t getRunningTaskTimeStringFormatted];
        [[cell time] setTextColor:[UIColor redColor]];
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
        [[cell time] setTextColor:defaultColor];
        // [[cell contentView] addSubview:myTimeLabel];
    }
    else if (indexPath.section == 2) {
        [[cell imageView] setImage:[TTImageManager getIcon:Project]];
        TTProject *myProject = (TTProject *)[_projects objectAtIndex:[indexPath row]];
        cell.label.text = [myProject name];
        cell.time.text = [[TTDatabase instance] getTotalProjectTimeStringFormatted:[myProject identifier]];
        [[cell time] setTextColor:defaultColor];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath indexAtPosition:0]) {
        case 0:
            if(!tableView.editing) {
                if(indexPath.row < [[TTDataManager instance] getNumberOfQuickRunningTasks]) {
                    // Quick running task.
                    [self showActionSheet:indexPath];
                } else {
                    // Running task.
                    TTRunningTask *t = [[[TTDataManager instance] getRunningTasks] objectAtIndex:indexPath.row - [[TTDataManager instance] getNumberOfQuickRunningTasks]];
                    [[TTDataManager instance] runTask:[t task]];
                    [self reloadData];
                }
            }
            break;
        case 1:
        {
            if(!tableView.editing) {
                if([indexPath indexAtPosition:1] == 0) {
                    TTAllTasksController *view = [[TTAllTasksController alloc] init];
                    [[self navigationController] pushViewController:view animated:YES];
                } else {
                    TTProjectTasksController *view = [[TTProjectTasksController alloc] initWithProject:0];
                    [[self navigationController] pushViewController:view animated:YES];
                }
            }
            break;
        }
        case 2:
        {
            TTProject *p = [_projects objectAtIndex:[indexPath row]];
            if(!tableView.editing) {
                // Show project tasks.
                TTProjectTasksController *view = [[TTProjectTasksController alloc] initWithProject:[p identifier]];
                [[self navigationController] pushViewController:view animated:YES];
            } else {
                // Edit project name.
                TTEditProjectController *view = [[TTEditProjectController alloc] initWithProject:p];
                [view setDelegate:self];
                [[self navigationController] pushViewController:view animated:YES];
            }
            break;
        }
        default:;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Allow editing only for projects.
    return [indexPath section] == 2;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch([indexPath indexAtPosition:0]) {
            case 0:
                break;
            case 1:
                break;
            case 2:
            {
                // Delete a project.
                TTProject *p = [_projects objectAtIndex:[indexPath row]];
                [[TTDatabase instance] deleteProject:p];
                [self reloadData];
                break;
            }
            default:;
        }
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
    [editController setDelegate:self];
    [[self navigationController] pushViewController:editController animated:YES];
}

- (IBAction)onEditTask:(id)sender {
    TTEditTaskController *editTaskController = [[TTEditTaskController alloc] initWithTask:nil];
    [[self navigationController] pushViewController:editTaskController animated:YES];
}

- (IBAction)btnQuickStart_TouchDown:(id)sender {
    TTTask *task = [[TTTask alloc]init];
    [task setName:[NSString stringWithFormat:@"Quick Task %d", [[TTDataManager instance] getNumberOfQuickRunningTasks] + 1]];
    NSDate *now = [NSDate date];
    TTRunningTask *runningTask = [[TTRunningTask alloc] initWithTask:task start:now];
    [[TTDataManager instance] addQuickRunningTask:runningTask];
    
    [self reloadData];
}

- (void)reloadTableViewForTimer {
    
    [self.tblView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)reloadData
{
    _projects = [[TTDatabase instance] getProjects];
    [[self tblView] reloadData];
    [_totalTimeButtonItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"Total : %@", @"Total time"), [[TTDatabase instance] getTotalTimeStringFormatted]]];
}

/** ActionSheet methods **/

// called when button inside actionsheet is clicked
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Supprimer"]) {
        [[TTDataManager instance] removeQuickRunningTaskAtIndex:[actionSheet tag]];
    }
    else if ([buttonTitle isEqualToString:@"Créer une nouvelle tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:[actionSheet tag]];
        TTEditTaskController *editTaskController = [[TTEditTaskController alloc] initWithRunningTask:runningTask];
        [editTaskController setDelegate:self];
        [[self navigationController] pushViewController:editTaskController animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Ajouter à une tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:[actionSheet tag]];
        TTSelectTaskController *selectTaskController = [[TTSelectTaskController alloc] initWithRunningTask:runningTask];
        [selectTaskController setDelegate:self];
        [[self navigationController] pushViewController:selectTaskController animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Ajouter à la tâche"]) {
        TTRunningTask *runningTask = [[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:[actionSheet tag]];
        [runningTask save];
        [[TTDataManager instance] removeQuickRunningTask:runningTask];
        [self reloadData];
        [self setTooBar];
    }
    else if ([buttonTitle isEqualToString:@"Annuler"]) {
        // On remet le end à nil puiqu'on continue la tache
        [[[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:[actionSheet tag]] setEnd:nil];
    }
}

// show actionsheet popup
- (void)showActionSheet:(id)sender
{
    NSDate *now = [NSDate date];
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    TTRunningTask *runningTask = [[[TTDataManager instance] getQuickRunningTasks] objectAtIndex:[indexPath row]];
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
    [[TTDataManager instance] removeQuickRunningTask:runningTask];
}

- (void)onCancel:(TTRunningTask *)runningTask
{
    [runningTask setEnd:nil];
}

-(void)onTaskSelected:(int)taskId :(TTRunningTask *)runningTask
{
    [runningTask setTask:[[TTDatabase instance] getTask:taskId]];
    [runningTask save];
    [[TTDataManager instance] removeQuickRunningTask:runningTask];
}

- (void)onSave:(TTProject *)original :(TTProject *)modified
{
    if(original) {
        [[TTDatabase instance] updateProject:modified];
    } else {
        [[TTDatabase instance] insertProject:modified];
    }
    [self reloadData];
}

- (void)onCancel
{
    
}

- (IBAction)showEmail:(UIBarButtonItem *)sender {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:NSLocalizedString(@"Export TimeTracker",@"Export email subject")];
    [mc addAttachmentData:[[[TTDatabase instance] getAllTimesCSVFormat] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:@"export_timetracker.csv"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
