//
//  TTEditTaskProtocol.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRunningTask.h"

@class TTTask;

/**
 Delegate for the edit task view.
 */
@protocol TTEditTaskDelegate <NSObject>

/**
 Called when edition has been canceled.
 */
- (void)onCancel;

/**
 Called when edition has been canceled.
 */
- (void)onCancel:(TTRunningTask *)runningTask;

/**
 Called when edition has been saved.
 @param original Original value.
 @param modified Edited value.
 */
- (void)onSave:(TTTask *)original :(TTTask *)modified;

/**
 Called when edition has been saved.
 @param runningTask Edited value.
 */
- (void)onSave:(TTRunningTask *)runningTask;

@end
