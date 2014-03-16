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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MiddleCell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MiddleCell"];
    }
    if (indexPath.section != 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [[cell viewWithTag:111] removeFromSuperview];
    [[cell viewWithTag:222] removeFromSuperview];
    
    if (indexPath.section == 0) {
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        [myImageView setTag:111];
        NSMutableArray *lstRunningTasks = [[TTDataManager instance] getRunningTasks];
        if (lstRunningTasks.count > indexPath.row)
        {
            TTRunningTask *myRunningTask = (TTRunningTask *)[lstRunningTasks objectAtIndex:indexPath.row];
            if ([[myRunningTask task] identifier] > 0){
                myImageView.image = [UIImage imageNamed:@"pause"];
                cell.textLabel.text = [[myRunningTask task] name];
                TTProject *myProject = [[TTDatabase instance] getProject:[[myRunningTask task] idProject]];
                if (myProject != nil){
                    cell.detailTextLabel.text = [myProject name];
                }
            }
            else {
                myImageView.image = [UIImage imageNamed:@"quickstart"];
                cell.textLabel.text = @"Quick Task";
            }
            
            [cell addSubview:myImageView];
            [cell setIndentationWidth:35];
            [cell setIndentationLevel:1];
            
            UILabel *myTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 80, 40)];
            [myTimeLabel setTag:222];
            [myTimeLabel setTextAlignment:NSTextAlignmentRight];
            [myTimeLabel setText:[myRunningTask getRunningTaskTimeStringFormatted]];
            [[cell contentView] addSubview:myTimeLabel];
                                
        }
        
    }
    else if (indexPath.section == 1){
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        [myImageView setTag:111];
        UILabel *myTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 40)];
        [myTimeLabel setTag:222];
        [myTimeLabel setTextAlignment:NSTextAlignmentRight];
        if (indexPath.row == 0) {
            myImageView.image = [UIImage imageNamed:@"tasks"];
            cell.textLabel.text = @"All Tasks";
            [myTimeLabel setText:[[TTDatabase instance] getTotalTimeStringFormatted]];
        }
        else if (indexPath.row == 1) {
            myImageView.image = [UIImage imageNamed:@"task"];
            cell.textLabel.text = @"Single Tasks";
            [myTimeLabel setText:[[TTDatabase instance] getTotalProjectTimeStringFormatted:0]];
            
        }
        [[cell contentView] addSubview:myTimeLabel];
        [cell addSubview:myImageView];
        [cell setIndentationWidth:35];
        [cell setIndentationLevel:1];
    }
    else if (indexPath.section == 2) {
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        [myImageView setTag:111];
        myImageView.image = [UIImage imageNamed:@"project"];
        UILabel *myTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 40)];
        [myTimeLabel setTag:222];
        [myTimeLabel setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:myImageView];
        [cell setIndentationWidth:35];
        [cell setIndentationLevel:1];
        
        NSMutableArray *lstProject = [NSMutableArray arrayWithArray:[[TTDatabase instance] getProjects]];
        if (lstProject.count > indexPath.row)
        {
            TTProject *myProject = (TTProject *)[lstProject objectAtIndex:indexPath.row];
            cell.textLabel.text = [myProject name];
            [myTimeLabel setText:[[TTDatabase instance] getTotalProjectTimeStringFormatted:[myProject identifier]]];
        }
        [[cell contentView] addSubview:myTimeLabel];
        
    }
    return cell;
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
