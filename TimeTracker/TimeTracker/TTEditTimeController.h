//
//  TTEditTimeController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTime;
@protocol TTEditTimeDelegate;

/**
 Controller for the edit time view.
 */
@interface TTEditTimeController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/**
 Delegate.
 */
@property (nonatomic, assign) id<TTEditTimeDelegate> delegate;

/**
 Initialize a new view.
 @param time Time to edit.
 @param task Task associated to the time.
 @return The initialized view.
 */
- (id)initWithTime:(TTTime *)time forTask:(int)task;

@end
