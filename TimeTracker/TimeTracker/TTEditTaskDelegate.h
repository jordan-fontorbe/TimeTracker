//
//  TTEditTaskProtocol.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTEditTaskController;

@protocol TTEditTaskDelegate <NSObject>

- (void)onCancel:(TTEditTaskController *)sender;
- (void)onSave:(TTEditTaskController *)sender;

@end
