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
@property (strong, nonatomic) NSMutableArray *daysString;
@property (strong, nonatomic) NSMutableDictionary *times;
@property (strong, nonatomic) NSDateFormatter *format;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIBarButtonItem *totalTimeButton;
- (void)onNewTime:(UIBarButtonItem *)sender;
- (TTTime *)timeAtIndex:(NSIndexPath *)indexPath;
- (void)setToolbar;
- (void)activateTimer;
- (void)deactivateTimer;
- (void)reloadData;

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
        _daysString = [[NSMutableArray alloc] init];
        _times = [[NSMutableDictionary alloc] init];
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
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setToolbarHidden:NO];
    [self setToolbar];
    [self activateTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deactivateTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setToolbar
{
    UIBarButtonItem *newTimeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNewTime:)];
    _totalTimeButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:newTimeButton, flexibleSpace, _totalTimeButton, flexibleSpace, nil]];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if(editing) {
        [self deactivateTimer];
    } else {
        [self activateTimer];
    }
    [super setEditing:editing animated:animated];
}

- (void)activateTimer
{
    [self reloadData];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
}

- (void)deactivateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)reloadData
{
    [_daysString removeAllObjects];
    [_times removeAllObjects];
    NSArray *a = [[TTDatabase instance] getTimesFor:[_task identifier]];
    for(TTTime *t in a) {
        NSString *s = [_format stringFromDate:[t start]];
        if(![_daysString containsObject:s]) {
            [_daysString addObject:s];
        }
        NSMutableArray *ma = [_times objectForKey:s];
        if(ma == nil) {
            ma = [[NSMutableArray alloc] init];
            [_times setObject:ma forKey:s];
        }
        [ma addObject:t];
    }
    [_totalTimeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Total : %@", @"Total time"), [[TTDatabase instance] getTotalTaskTimeStringFormatted:[_task identifier]]]];
    [[self tableView] reloadData];
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
    if(original) {
        [[TTDatabase instance] updateTime:modified];
    } else {
        [[TTDatabase instance] insertTime:modified];
    }
    [self reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_daysString count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_times objectForKey:[_daysString objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_daysString objectAtIndex:section];
}

- (TTTime *)timeAtIndex:(NSIndexPath *)indexPath
{
    return [[_times objectForKey:[_daysString objectAtIndex:[indexPath indexAtPosition:0]]] objectAtIndex:[indexPath indexAtPosition:1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static UIColor *defaultLabelColor = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(defaultLabelColor == nil) {
        defaultLabelColor = [[cell detailTextLabel] textColor];
    }
    
    TTTime *time = [self timeAtIndex:indexPath];
    [[cell textLabel] setText:[time formatInterval]];
    [[cell detailTextLabel] setText:[time formatDuration]];
    if([time end] == nil) {
        [[cell detailTextLabel] setTextColor:[UIColor redColor]];
    } else {
        [[cell detailTextLabel] setTextColor:defaultLabelColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Can't delete the running time.
        TTTime *t = [self timeAtIndex:indexPath];
        if([t end] != nil) {
            [[TTDatabase instance] deleteTime:t];
            [self reloadData];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Can't edit the running time.
    TTTime *t = [self timeAtIndex:indexPath];
    return [t end] != nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Can't select the running time.
    TTTime *t = [self timeAtIndex:indexPath];
    if([t end] != nil) {
        TTEditTimeController *view = [[TTEditTimeController alloc] initWithTime:t forTask:[_task identifier]];
        [view setDelegate:self];
        [[self navigationController] pushViewController:view animated:YES];
    }
}

@end
