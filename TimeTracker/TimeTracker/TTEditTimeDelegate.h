//
//  TTEditTimeDelegate.h
//  TimeTracker
//
//  Created by Jérémy Morosi on 20/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTTime;

/**
 Delegate for the edit time view.
 */
@protocol TTEditTimeDelegate <NSObject>

/**
 Called when edition has been canceled.
 */
- (void)onCancel;

/**
 Called when edition has been saved.
 @param original Original value.
 @param modified Edited value.
 */
- (void)onSave:(TTTime *)original :(TTTime *)modified;

@end
