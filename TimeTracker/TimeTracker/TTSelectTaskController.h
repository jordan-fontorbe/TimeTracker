//
//  TTSelectTaskController.h
//  TimeTracker
//
//  Created by Lion User on 21/03/14.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRunningTask.h"

@protocol TTSelectTaskDelegate;

/**
 Controller for the select task view.
 */
@interface TTSelectTaskController : UITableViewController

/**
 Delegate.
 */
@property (nonatomic, assign) id<TTSelectTaskDelegate> delegate;

/**
 Initialize a new view.
 @param runningTask Running task.
 @return The initialized view.
 */
- (id)initWithRunningTask:(TTRunningTask *)runningTask;

@end
