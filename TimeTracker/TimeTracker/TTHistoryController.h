//
//  TTHistoryController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEditTimeDelegate.h"

/**
 Controller for the history view.
 */
@interface TTHistoryController : UITableViewController <TTEditTimeDelegate>

/**
 Initialize a new view.
 @param task Identifier of the task.
 @return The initialized view.
 */
- (id)initWithTask:(int)task;

@end
