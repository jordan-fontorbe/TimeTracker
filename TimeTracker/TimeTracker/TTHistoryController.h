//
//  TTHistoryController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEditTimeDelegate.h"

@interface TTHistoryController : UITableViewController <TTEditTimeDelegate>

- (id)initWithTask:(int)task;

@end
