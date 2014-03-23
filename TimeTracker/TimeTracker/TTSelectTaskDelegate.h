//
//  TTSelectTaskDelegate.h
//  TimeTracker
//
//  Created by Lion User on 21/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTSelectTaskController;

@protocol TTSelectTaskDelegate <NSObject>

- (void)onTaskSelected:(int)taskId :(TTRunningTask *)runningTask;
- (void)onCancel:(TTRunningTask *)runningTask;

@end
