//
//  TTSelectTaskDelegate.h
//  TimeTracker
//
//  Created by Lion User on 21/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTSelectTaskController;

/**
 Delegate for the select task view.
 */
@protocol TTSelectTaskDelegate <NSObject>

/**
 Called when a task has been selected.
 @param taskId Selected task identifier.
 @param runningTask Running task.
 */
- (void)onTaskSelected:(int)taskId :(TTRunningTask *)runningTask;

/**
 Called when selection has been canceled.
 @param runningTask Running task.
 */
- (void)onCancel:(TTRunningTask *)runningTask;

@end
