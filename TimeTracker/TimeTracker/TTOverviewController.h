//
//  TTOverviewController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTEditTaskDelegate.h"
#import "TTSelectTaskDelegate.h"
#import "TTEditProjectDelegate.h"

@interface TTOverviewController : UIViewController <UIActionSheetDelegate, TTEditTaskDelegate, TTSelectTaskDelegate, TTEditProjectDelegate>


- (IBAction)onEditTask:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *btnQuickStart;
- (IBAction)btnQuickStart_TouchDown:(id)sender;

@end
