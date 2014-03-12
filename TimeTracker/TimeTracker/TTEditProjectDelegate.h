//
//  TTEditProjectDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTProject;

@protocol TTEditProjectDelegate <NSObject>

- (void)onCancel;
- (void)onSave:(TTProject *)project;

@end
