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

@protocol TTDatabaseProtocol <NSObject>

- (void)createDatabase;
- (void)clear;

- (TTProject *)getProject:(int)identifier;
- (TTTask *)getTask:(int)identifier;
- (TTTime *)getTime:(int)identifier;

- (NSArray *)getProjects;
- (NSArray *)getTasks;

- (int)insertProject:(TTProject *)newProject;
- (int)insertTask:(TTTask *)newTask;
- (int)insertTime:(TTTime *)newTime;

- (void)updateProject:(TTProject *)updateProject;
- (void)updateTask:(TTTask *)updateTask;
- (void)updateTime:(TTTime *)updateTime;

- (void)deleteProject:(TTProject *)project;
- (void)deleteTask:(TTTask *)task;
- (void)deleteTime:(TTTime *)time;

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project;

- (NSString *)getTotalTimeStringFormatted;
- (NSString *)getTotalProjectTimeStringFormatted:(NSInteger) idProject;
@end
