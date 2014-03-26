//
//  TTEditTaskController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSelectProjectDelegate.h"

@class TTTask;
@class TTRunningTask;
@protocol TTEditTaskDelegate;

/**
 Controller for the edit task view.
 */
@interface TTEditTaskController : UITableViewController <TTSelectProjectDelegate, UITextFieldDelegate>

/**
 Delegate.
 */
@property (nonatomic, assign) id<TTEditTaskDelegate> delegate;

/**
 Initialize a new view.
 @param task Task to edit.
 @return The initialized view.
 */
- (id)initWithTask:(TTTask *)task;

/**
 Initialize a new view.
 @param task Task to edit.
 @param project Project associated to the task.
 @return The initialized view.
 */
- (id)initWithTask:(TTTask *)task forProject:(int)project;

/**
 Initialize a new view.
 @param runningTask Task to edit.
 @return The initialized view.
 */
- (id)initWithRunningTask:(TTRunningTask *)runningTask;

@end
