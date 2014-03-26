//
//  TTOverviewController.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TTEditTaskDelegate.h"
#import "TTSelectTaskDelegate.h"
#import "TTEditProjectDelegate.h"

/**
 Controller for the overview.
 */
@interface TTOverviewController : UIViewController <UIActionSheetDelegate, TTEditTaskDelegate, TTSelectTaskDelegate, TTEditProjectDelegate, MFMailComposeViewControllerDelegate>

/**
 Called when user click on the "Edit" button.
 @param sender Button.
 */
- (IBAction)onEditTask:(id)sender;

/**
 Table.
 */
@property (weak, nonatomic) IBOutlet UITableView *tblView;

/**
 QuickStart button.
 */
@property (weak, nonatomic) IBOutlet UIButton *btnQuickStart;

/**
 Called when user click on the "QuickStart" button.
 @param sender Button.
 */
- (IBAction)btnQuickStart_TouchDown:(id)sender;

@end
