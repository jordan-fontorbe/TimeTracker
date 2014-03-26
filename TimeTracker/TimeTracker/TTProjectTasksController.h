//
//  TTProjectTasksController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTasksListController.h"

/**
 Controller for the view displaying the list of tasks of a project.
 */
@interface TTProjectTasksController : TTTasksListController

/**
 Initialize a new view.
 @param project Identifier of the project.
 @return The initialized view.
 */
- (id)initWithProject:(int)project;

@end
