//
//  TTTextFieldCell.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 17/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Custom table view cell with a text field for editing tasks or projects names.
 */
@interface TTTextFieldCell : UITableViewCell

/**
 Text field.
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
