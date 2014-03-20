//
//  TTEditTaskProtocol.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRunningTask.h"

@class TTTask;

@protocol TTEditTaskDelegate <NSObject>

- (void)onCancel;
- (void)onCancel:(TTRunningTask *)runningTask;
- (void)onSave:(TTTask *)original :(TTTask *)modified;
- (void)onSave:(TTRunningTask *)runningTask;

@end
