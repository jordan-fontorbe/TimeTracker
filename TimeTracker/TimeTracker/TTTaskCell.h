//
//  TTTaskCell.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Custom table view cell for tasks.
 */
@interface TTTaskCell : UITableViewCell

/**
 Label for displaying the task's name.
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/**
 Label for displaying the task total time.
 */
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
