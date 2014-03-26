//
//  TTAllTasksController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEditTaskDelegate.h"

/**
 Controller for the view displaying a list of tasks.
 */
@interface TTTasksListController : UITableViewController <TTEditTaskDelegate>

/**
 Reload data for the table.
 */
- (void)reloadData;

@end
