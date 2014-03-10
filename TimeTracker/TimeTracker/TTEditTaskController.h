//
//  TTEditTaskViewController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTask;
@protocol TTEditTaskDelegate;

@interface TTEditTaskController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil task:(TTTask *)task;
@property (nonatomic, assign) id<TTEditTaskDelegate> delegate;
@property (nonatomic, readonly) TTTask *task;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;

@end
