//
//  TTEditTaskViewController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 07/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTask;

@interface TTEditTaskController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil task:(TTTask *)task;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;

@end
