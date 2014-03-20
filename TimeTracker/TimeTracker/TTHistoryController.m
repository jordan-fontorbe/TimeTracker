//
//  TTHistoryController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTHistoryController.h"
#import "TTTask.h"
#import "TTTime.h"
#import "TTDatabase.h"
#import "TTEditTimeController.h"

@interface TTHistoryController ()

@property (strong, nonatomic) TTTask *task;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *daysString;
@property (strong, nonatomic) NSMutableDictionary *times;
@property (strong, nonatomic) NSDateFormatter *format;
- (void)onNewTime:(UIBarButtonItem *)sender;
- (TTTime *)timeAtIndex:(NSIndexPath *)indexPath;

@end

@implementation TTHistoryController

- (id)initWithTask:(int)task
{
    self = [self initWithStyle:UITableViewStylePlain];
    if(self) {
        _task = [[TTDatabase instance] getTask:task];
        [self setTitle:[_task name]];
        // Date format.
        _format = [[NSDateFormatter alloc] init];
        [_format setDateFormat:NSLocalizedString(@"dd/MM/YY", @"Date format")];
        // Get the times.
        _days = [[NSMutableArray alloc] init];
        _daysString = [[NSMutableArray alloc] init];
        _times = [[NSMutableDictionary alloc] init];
        NSArray *a = [[TTDatabase instance] getTimesFor:task];
        for(TTTime *t in a) {
            NSDateComponents *c = [t startComponents];
            if(![_days containsObject:c]) {
                [_days addObject:c];
                [_daysString addObject:[_format stringFromDate:[t start]]];
            }
            NSMutableArray *ma = [_times objectForKey:c];
            if(ma == nil) {
                ma = [[NSMutableArray alloc] init];
                [_times setObject:ma forKey:c];
            }
            [ma addObject:t];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *newTimeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewTime:)];
    [self setToolbarItems:[NSArray arrayWithObjects:newTimeButton, nil]];
    [[self navigationController] setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onNewTime:(UIBarButtonItem *)sender
{
    TTEditTimeController *view = [[TTEditTimeController alloc] initWithTime:nil forTask:[_task identifier]];
    [view setDelegate:self];
    [[self navigationController] pushViewController:view animated:YES];
}

#pragma mark - Edit time delegate

- (void)onCancel
{
}

- (void)onSave:(TTTime *)original :(TTTime *)modified
{

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_days count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_times objectForKey:[_days objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_daysString objectAtIndex:section];
}

- (TTTime *)timeAtIndex:(NSIndexPath *)indexPath
{
    return [[_times objectForKey:[_days objectAtIndex:[indexPath indexAtPosition:0]]] objectAtIndex:[indexPath indexAtPosition:1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    TTTime *time = [self timeAtIndex:indexPath];
    [[cell textLabel] setText:[time formatInterval]];
    [[cell detailTextLabel] setText:[time formatDuration]];
    
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

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Table view delegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     TTTime *t = [self timeAtIndex:indexPath];
     TTEditTimeController *view = [[TTEditTimeController alloc] initWithTime:t forTask:[_task identifier]];
     [view setDelegate:self];
     [[self navigationController] pushViewController:view animated:YES];
 }

@end
