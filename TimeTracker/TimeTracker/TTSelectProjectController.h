//
//  TTSelectProjectController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTSelectProjectDelegate;

/**
 Controller for the select project view.
 */
@interface TTSelectProjectController : UITableViewController

/**
 Delegate.
 */
@property (nonatomic, assign) id<TTSelectProjectDelegate> delegate;

/**
 Initialize a new view.
 @param projectId Selected project identifier.
 @return The initialized view.
 */
- (id)initWithProject:(int)projectId;

@end
