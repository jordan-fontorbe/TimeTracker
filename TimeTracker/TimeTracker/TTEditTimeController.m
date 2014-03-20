//
//  TTEditTimeController.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTEditTimeController.h"
#import "TTEditTimeDelegate.h"
#import "TTTask.h"
#import "TTTime.h"
#import "TTDatabase.h"

@interface TTEditTimeController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) TTTime *time;
@property (strong, nonatomic) TTTime *timeTmp;
@property int selection;
- (void)onCancel:(UIBarButtonItem *)sender;
- (void)onSave:(UIBarButtonItem *)sender;
- (void)onSelected:(int)index;

@end

@implementation TTEditTimeController

@synthesize delegate;

- (id)initWithTime:(TTTime *)time forTask:(int)task
{
    self = [self initWithNibName:@"TTEditTimeController" bundle:nil];
    if(self) {
        if(time) {
            _time = time;
            _timeTmp = [[TTTime alloc] initWithTime:time];
        } else {
            // Current date.
            NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
            [c setMinute:0];
            [c setSecond:0];
            NSDate *s = [[NSCalendar currentCalendar] dateFromComponents:c];
            c = [[NSDateComponents alloc] init];
            [c setHour:1];
            NSDate *e = [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:s options:0];
            _time = nil;
            _timeTmp = [[TTTime alloc] initWithStart:s end:e task:task];
        }
        TTTask *t = [[TTDatabase instance] getTask:task];
        [self setTitle:[t name]];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Picker.
    // Table.
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    // Navigation bar.
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)]];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)]];
    [[self datePicker] setEnabled:YES];
    [[self datePicker] setHidden:NO];
    [self onSelected:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onCancel:(UIBarButtonItem *)sender
{
    [[self delegate] onCancel];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSave:(UIBarButtonItem *)sender
{
    [[self delegate] onSave:_time :_timeTmp];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSelected:(int)index
{
    _selection = index;
    switch(index) {
        case 0:
            [[self datePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
            [[self datePicker] setDate:[_timeTmp start]];
            break;
        case 1:
            [[self datePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
            [[self datePicker] setDate:[_timeTmp end]];
            break;
        case 2:
            [[self datePicker] setDatePickerMode:UIDatePickerModeTime];
            break;
        default:;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    switch([indexPath indexAtPosition:1]) {
        case 0:
            [[cell textLabel] setText:NSLocalizedString(@"Start", @"Start")];
            [[cell detailTextLabel] setText:[_timeTmp formatStart]];
            break;
        case 1:
            [[cell textLabel] setText:NSLocalizedString(@"End", @"End")];
            [[cell detailTextLabel] setText:[_timeTmp formatHourEnd]];
            break;
        case 2:
            [[cell textLabel] setText:NSLocalizedString(@"Duration", @"Duration")];
            [[cell detailTextLabel] setText:[_timeTmp formatDuration]];
            break;
        default:;
    }
    
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
    [self onSelected:[indexPath indexAtPosition:1]];
}

@end
