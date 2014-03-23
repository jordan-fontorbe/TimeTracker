//
//  TTDataManager.m
//  TimeTracker
//
//  Created by Lion User on 12/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDataManager.h"
#import "TTRunningTask.h"
#import "TTTask.h"
#import "TTDatabase.h"

@interface TTDataManager ()

@property (strong, nonatomic) NSMutableDictionary *projectRunningTasks;
@property (strong, nonatomic) NSMutableDictionary *taskRunningTask;
@property (strong, nonatomic) NSMutableArray *quickRunningTasks;
- (NSMutableArray *)getRunningTasksArrayFor:(int)project;

@end

@implementation TTDataManager

static TTDataManager* _instance = nil;

+(TTDataManager*)instance
{
    @synchronized([TTDataManager class])
    {
        if (!_instance)
            [[self alloc] init];
        return _instance;
    }
    return nil;
}

+(id)alloc
{
	@synchronized([TTDataManager class])
	{
		NSAssert(_instance == nil,
                 @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)initRunningTasks
{
    _projectRunningTasks = [[NSMutableDictionary alloc] init];
    _taskRunningTask = [[NSMutableDictionary alloc] init];
    _quickRunningTasks = [[NSMutableArray alloc] init];
}

- (NSMutableArray *)getRunningTasksArrayFor:(int)project
{
    NSNumber *n = [NSNumber numberWithInt:project];
    NSMutableArray *a = [_projectRunningTasks objectForKey:n];
    if(a == nil) {
        a = [[NSMutableArray alloc] init];
        [_projectRunningTasks setObject:a forKey:n];
    }
    return a;
}

- (void)addRunningTask:(TTRunningTask *)runningTask
{
    [[self getRunningTasksArrayFor:[[runningTask task] idProject]] addObject:runningTask];
    [_taskRunningTask setObject:runningTask forKey:[NSNumber numberWithInt:[[runningTask task] identifier]]];
}

- (void)removeRunningTask:(TTRunningTask *)runningTask
{
    [[self getRunningTasksArrayFor:[[runningTask task] idProject]] removeObject:runningTask];
    [_taskRunningTask removeObjectForKey:[NSNumber numberWithInt:[[runningTask task] identifier]]];
}

- (void)addQuickRunningTask:(TTRunningTask *)runningTask
{
    [_quickRunningTasks addObject:runningTask];
}

- (void)removeQuickRunningTask:(TTRunningTask *)runningTask
{
    [_quickRunningTasks removeObject:runningTask];
}

- (void)removeQuickRunningTaskAtIndex:(int)index
{
    [_quickRunningTasks removeObjectAtIndex:index];
}

- (NSArray *)getRunningTasks
{
    return [_taskRunningTask allValues];
}

- (NSArray *)getRunningTasksFor:(int)project
{
    return [self getRunningTasksArrayFor:project];
}

- (TTRunningTask *)getRunningTaskFor:(int)task
{
    return [_taskRunningTask objectForKey:[NSNumber numberWithInt:task]];
}

- (NSArray *)getQuickRunningTasks
{
    return _quickRunningTasks;
}

- (bool)isRunningTask:(int)task
{
    return [self getRunningTaskFor:task] != nil;
}

- (void)runTask:(TTTask *)task
{
    TTRunningTask *t = [self getRunningTaskFor:[task identifier]];
    if(t) {
        // Stop the task.
        [self removeRunningTask:t];
        [t setEnd:[NSDate date]];
        [[TTDatabase instance] insertTime:t];
    } else {
        // Start the task.
        [self addRunningTask:[[TTRunningTask alloc] initWithTask:task start:[NSDate date]]];
    }
}

- (NSInteger)getTotalNumberOfRunningTasks
{
    return [[self getRunningTasks] count] + [self getNumberOfQuickRunningTasks];
}

- (NSInteger)getNumberOfQuickRunningTasks
{
    return [_quickRunningTasks count];
}

@end
