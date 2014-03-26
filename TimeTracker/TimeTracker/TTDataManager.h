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

/**
 Manager for the running tasks.
 */
@interface TTDataManager : NSObject

/**
 Get the unique instance of this manager.
 @return The unique instance.
 */
+(TTDataManager*)instance;

/**
 Initialize the list of running tasks.
 */
-(void)initRunningTasks;

/**
 Add the given running task.
 @param runningTask Running task to add.
 */
- (void)addRunningTask:(TTRunningTask *)runningTask;

/**
 Remove the given running task.
 @param runningTask Running task to remove.
 */
- (void)removeRunningTask:(TTRunningTask *)runningTask;

/**
 Add the given quick running task.
 @param runningTask quick Running task to add.
 */
- (void)addQuickRunningTask:(TTRunningTask *)runningTask;

/**
 Remove the given quick running task.
 @param runningTask quick Running task to remove.
 */
- (void)removeQuickRunningTask:(TTRunningTask *)runningTask;

/**
 Remove the quick running task at the given index.
 @param index Index to remove.
 */
- (void)removeQuickRunningTaskAtIndex:(int)index;

/**
 Get the running tasks.
 @return The running tasks.
 */
- (NSArray *)getRunningTasks;

/**
 Get the running tasks for the given project.
 @param project Identifier of the project.
 @return The running tasks.
 */
- (NSArray *)getRunningTasksFor:(int)project;

/**
 Get the running task associated to the given task.
 @param task Identifier of the task.
 @return The running task.
 */
- (TTRunningTask *)getRunningTaskFor:(int)task;

/**
 Get the quick running tasks.
 @return The quick running tasks.
 */
- (NSArray *)getQuickRunningTasks;

/**
 Indicate if the given task is a running task.
 @param task Identifier of the task.
 @return If it is a running task.
 */
- (bool)isRunningTask:(int)task;

/**
 Run the given task.
 @param task Task to run.
 */
- (void)runTask:(TTTask *)task;

/**
 Get the total number of running tasks.
 @return The total number of running tasks.
 */
- (NSInteger)getTotalNumberOfRunningTasks;

/**
 Get the total number of quick running tasks.
 @return The total number of quick running tasks.
 */
- (NSInteger)getNumberOfQuickRunningTasks;

@end
