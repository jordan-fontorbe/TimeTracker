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

@property (strong, nonatomic) NSMutableArray *lstRunningTasks;
- (void)addRunningTask:(TTRunningTask *)runningTask;
- (void)removeRunningTask:(TTRunningTask *)runningTask;

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
    _lstRunningTasks = [[NSMutableArray alloc] init];
}

- (void)addRunningTask:(TTRunningTask *)runningTask
{
    [_lstRunningTasks addObject:runningTask];
}

- (void)removeRunningTask:(TTRunningTask *)runningTask
{
    [_lstRunningTasks removeObject:runningTask];
}

- (NSMutableArray *)getRunningTasks
{
    if (_lstRunningTasks == nil)
    {
        _lstRunningTasks = [[NSMutableArray alloc] init];
    }
    return _lstRunningTasks;
}

- (NSArray *)getRunningTasksFor:(int)project
{
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for(TTRunningTask *t in _lstRunningTasks) {
        if([[t task] idProject] == project) {
            [a addObject:t];
        }
    }
    return a;
}

- (TTRunningTask *)getRunningTaskFor:(int)task
{
    for(TTRunningTask *t in _lstRunningTasks) {
        if([t idTask] == task) {
            return t;
        }
    }
    return nil;
}

-(void)setRunningTasks:(NSMutableArray*)newRunningTasks
{
    _lstRunningTasks = [NSMutableArray arrayWithArray:newRunningTasks];
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

-(NSInteger)getNumberOfQuickRunningTasks
{
    NSInteger res = 0;
    if (_lstRunningTasks != nil)
    {
        for (NSInteger i = 0; i < _lstRunningTasks.count; i++) {
            TTRunningTask *runnningTask = (TTRunningTask *)[_lstRunningTasks objectAtIndex:i];
            TTTask *task = [runnningTask task];
            if ([task identifier] == 0){
                ++res;
            }
        }
    }
    return res;
}

@end
