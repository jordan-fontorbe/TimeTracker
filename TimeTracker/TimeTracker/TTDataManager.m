//
//  TTDataManager.m
//  TimeTracker
//
//  Created by Lion User on 12/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDataManager.h"

@interface TTDataManager ()

@property (strong, nonatomic) NSMutableArray *lstRunningTasks;

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

-(NSMutableArray *)getRunningTasks
{
    if (_lstRunningTasks == nil)
    {
        _lstRunningTasks = [[NSMutableArray alloc] init];
    }
    return _lstRunningTasks;
}

-(void)setRunningTasks:(NSMutableArray*)newRunningTasks
{
    _lstRunningTasks = [NSMutableArray arrayWithArray:newRunningTasks];
}

@end
