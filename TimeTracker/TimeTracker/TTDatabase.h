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

- (TTTask *)getTask:(int)identifier;
- (TTTime *)getTime:(int)identifier;
- (TTProject *)getProject:(int)identifier;

- (TTTask *)insertTask:(TTTask *)newTask;
- (TTTime *)insertTime:(TTTime *)newTime;
- (TTProject *)insertProject:(TTProject *)newProject;

- (TTTask *)updateTask:(TTTask *)updateTask;
- (TTTime *)updateTime:(TTTime *)updateTime;
- (TTProject *)updateProject:(TTProject *)updateProject;

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to;
@end
