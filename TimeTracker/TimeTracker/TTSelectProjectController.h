//
//  TTSelectProjectController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTSelectProjectDelegate;

@interface TTSelectProjectController : UITableViewController

@property (nonatomic, assign) id<TTSelectProjectDelegate> delegate;
- (id)initWithSelectedProject:(int)selectedProjectId;

@end
