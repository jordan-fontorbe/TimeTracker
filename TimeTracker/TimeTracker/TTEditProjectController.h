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

@interface TTEditProjectController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<TTEditProjectDelegate> delegate;
- (id)initWithProject:(TTProject *)project;

@end
