//
//  TTDataManager.h
//  TimeTracker
//
//  Created by Lion User on 12/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTRunningTask;

@interface TTDataManager : NSObject

+(TTDataManager*)instance;

-(void)initRunningTasks;

- (NSMutableArray *)getRunningTasks;
- (TTRunningTask *)getRunningTaskFor:(int)task;

-(void)setRunningTasks:(NSMutableArray*)newRunningTasks;

-(NSInteger)getNumberOfQuickRunningTasks;

@end
