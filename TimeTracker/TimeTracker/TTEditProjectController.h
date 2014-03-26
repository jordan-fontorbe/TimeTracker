//
//  TTEditProjectController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTProject;
@protocol TTEditProjectDelegate;

/**
 Controller for the edit project view.
 */
@interface TTEditProjectController : UITableViewController <UITextFieldDelegate>

/**
 Delegate.
 */
@property (nonatomic, assign) id<TTEditProjectDelegate> delegate;

/**
 Initialize a new view.
 @param project Project to edit.
 @return The initialized view.
 */
- (id)initWithProject:(TTProject *)project;

@end
