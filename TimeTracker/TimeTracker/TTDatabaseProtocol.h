//
//  TimeTrackerDatabase.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTask;
@class TTTime;
@class TTProject;

/**
 Protocol for the database.
 */
@protocol TTDatabaseProtocol <NSObject>

/**
 Create the database.
 */
- (void)createDatabase;

/**
 Clear the database.
 */
- (void)clear;

/**
 Get the project with the given identifier.
 @param identifier Project's identifier.
 @return The project.
 */
- (TTProject *)getProject:(int)identifier;

/**
 Get the task with the given identifier.
 @param identifier Task's identifier.
 @return The task.
 */
- (TTTask *)getTask:(int)identifier;

/**
 Get the time with the given identifier.
 @param identifier Time's identifier.
 @return The time.
 */
- (TTTime *)getTime:(int)identifier;

/**
 Get the projects.
 @return The projects.
 */
- (NSArray *)getProjects;

/**
 Get the tasks.
 @return The tasks.
 */
- (NSDictionary *)getTasks;

/**
 Insert a new project.
 @param newProject Project to insert.
 @return The identifier of inserted project.
 */
- (int)insertProject:(TTProject *)newProject;

/**
 Insert a new task.
 @param newTask Task to insert.
 @return The identifier of inserted task.
 */
- (int)insertTask:(TTTask *)newTask;

/**
 Insert a new time.
 @param newTime Time to insert.
 @return The identifier of inserted time.
 */
- (int)insertTime:(TTTime *)newTime;

/**
 Update a project.
 @param updateProject Project to update.
 */
- (void)updateProject:(TTProject *)updateProject;

/**
 Update a task.
 @param updateTask Task to update.
 */
- (void)updateTask:(TTTask *)updateTask;

/**
 Update a time.
 @param updateTime Time to update.
 */
- (void)updateTime:(TTTime *)updateTime;

/**
 Delete a project.
 @param project Project to delete.
 */
- (void)deleteProject:(TTProject *)project;

/**
 Delete a task.
 @param task Task to delete.
 */
- (void)deleteTask:(TTTask *)task;

/**
 Delete a time.
 @param time Time to delete.
 */
- (void)deleteTime:(TTTime *)time;

/**
 Get the tasks for the given project.
 @param project Identifier of the project.
 @return The tasks for the project.
 */
- (NSArray *)getTasksFor:(int)project;

/**
 Get the times for the given task.
 @param task Identifier of the task.
 @return The times for the task.
 */
- (NSArray *)getTimesFor:(int)task;

/**
 Get the total time (all tasks) formatted.
 @return The total time formatted.
 */
- (NSString *)getTotalTimeStringFormatted;

/**
 Get the total time for the given project formatted.
 @param idProject Identifier of the project.
 @return The total time formatted.
 */
- (NSString *)getTotalProjectTimeStringFormatted:(NSInteger) idProject;

/**
 Get the total time for the given task formatted.
 @param idTask Identifier of the task.
 @return The total time formatted.
 */
- (NSString *)getTotalTaskTimeStringFormatted:(NSInteger) idTask;

/**
 Get all the times in the CSV format.
 @return All the times in the CSV format.
 */
- (NSString *)getAllTimesCSVFormat;

@end
