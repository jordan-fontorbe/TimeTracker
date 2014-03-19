//
//  TTEditTaskProtocol.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 10/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTask;

@protocol TTEditTaskDelegate <NSObject>

- (void)onCancel;
- (void)onSave:(TTTask *)original :(TTTask *)modified;

@end
