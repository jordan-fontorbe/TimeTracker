//
//  TTDataManager.h
//  TimeTracker
//
//  Created by Lion User on 12/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTRunningTask;
@class TTTask;

@interface TTDataManager : NSObject

+(TTDataManager*)instance;

-(void)initRunningTasks;

- (NSMutableArray *)getRunningTasks;
- (NSArray *)getRunningTasksFor:(int)project;
- (TTRunningTask *)getRunningTaskFor:(int)task;

-(void)setRunningTasks:(NSMutableArray*)newRunningTasks;

- (bool)isRunningTask:(int)task;
- (void)runTask:(TTTask *)task;

-(NSInteger)getNumberOfQuickRunningTasks;

@end
