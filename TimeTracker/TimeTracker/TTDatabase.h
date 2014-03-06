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

@end
