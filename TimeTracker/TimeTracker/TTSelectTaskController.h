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

@interface TTSelectTaskController : UITableViewController

@property (nonatomic, assign) id<TTSelectTaskDelegate> delegate;

- (id)initWithRunningTask:(TTRunningTask *)runningTask;

@end
