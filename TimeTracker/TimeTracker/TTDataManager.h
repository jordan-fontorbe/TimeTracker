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

- (void)addRunningTask:(TTRunningTask *)runningTask;
- (void)removeRunningTask:(TTRunningTask *)runningTask;
- (void)addQuickRunningTask:(TTRunningTask *)runningTask;
- (void)removeQuickRunningTask:(TTRunningTask *)runningTask;
- (void)removeQuickRunningTaskAtIndex:(int)index;

- (NSArray *)getRunningTasks;
- (NSArray *)getRunningTasksFor:(int)project;
- (TTRunningTask *)getRunningTaskFor:(int)task;
- (NSArray *)getQuickRunningTasks;

- (bool)isRunningTask:(int)task;
- (void)runTask:(TTTask *)task;

- (NSInteger)getTotalNumberOfRunningTasks;
- (NSInteger)getNumberOfQuickRunningTasks;

@end
