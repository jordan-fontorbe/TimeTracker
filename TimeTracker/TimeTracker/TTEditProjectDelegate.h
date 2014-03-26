//
//  TTEditProjectDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 12/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTProject;

/**
 Delegate for the edit project view.
 */
@protocol TTEditProjectDelegate <NSObject>

/**
 Called when edition has been canceled.
 */
- (void)onCancel;

/**
 Called when edition has been saved.
 @param original Original value.
 @param modified Edited value.
 */
- (void)onSave:(TTProject *)original :(TTProject *)modified;

@end
