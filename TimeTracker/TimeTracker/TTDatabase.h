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

@protocol TTDatabase <NSObject>

- (TTProject *)getProject:(int)identifier;
- (TTTask *)getTask:(int)identifier;
- (TTTime *)getTime:(int)identifier;

- (NSArray *)getProjects;
- (NSArray *)getTasks;

- (void)insertProject:(TTProject *)newProject;
- (void)insertTask:(TTTask *)newTask;
- (void)insertTime:(TTTime *)newTime;

- (void)updateProject:(TTProject *)updateProject;
- (void)updateTask:(TTTask *)updateTask;
- (void)updateTime:(TTTime *)updateTime;

- (void)deleteProject:(TTProject *)project;
- (void)deleteTask:(TTTask *)task;
- (void)deleteTime:(TTTime *)time;

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project;
@end
