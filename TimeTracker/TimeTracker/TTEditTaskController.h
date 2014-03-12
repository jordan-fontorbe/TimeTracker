//
//  TTEditTaskController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSelectProjectDelegate.h"

@class TTTask;
@protocol TTEditTaskDelegate;

@interface TTEditTaskController : UITableViewController <TTSelectProjectDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<TTEditTaskDelegate> delegate;
- (id)initWithTask:(TTTask *)task;

@end
